USE p4g7;
GO

CREATE OR ALTER PROCEDURE dbo.sp_login_user
    @email    VARCHAR(255),
    @password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, user_name, email, age, gender, height, weight, goal
    FROM users
    WHERE email = @email AND password = @password;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_register_user
    @user_name VARCHAR(255),
    @email     VARCHAR(255),
    @password  VARCHAR(255),
    @age       INT,
    @gender    VARCHAR(20),
    @height    FLOAT,
    @weight    FLOAT,
    @goal      VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM users WHERE email = @email)
        THROW 50030, 'An account with this email already exists.', 1;

    IF EXISTS (SELECT 1 FROM users WHERE user_name = @user_name)
        THROW 50031, 'This username is already taken.', 1;

    DECLARE @new_id INT = (SELECT ISNULL(MAX(user_id), 0) + 1 FROM users);

    INSERT INTO users (user_id, user_name, email, password, age, gender, height, weight, goal)
    VALUES (@new_id, @user_name, @email, @password, @age, @gender, @height, @weight, @goal);

    SELECT @new_id AS user_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_all_meals
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        m.meal_id,
        m.meal_name,
        CAST(ROUND((m.quantity * f.calories_per_100g) / 100.0, 0) AS INT) AS calories
    FROM meals m
    JOIN foods f ON f.food_id = m.food_id
    ORDER BY m.meal_name;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_all_diet_plans
AS
BEGIN
    SET NOCOUNT ON;
    SELECT diet_plan_id, plan_name, description
    FROM diet_plans
    ORDER BY plan_name;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_all_subscription_plans
AS
BEGIN
    SET NOCOUNT ON;
    SELECT subscription_plan_id, subscription_name, price, duration_days, features
    FROM subscription_plans
    ORDER BY price;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_user_profile
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM vw_user_profile WHERE user_id = @user_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_user_progress_history
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT date, weight, ISNULL(notes, '') AS notes
    FROM progress
    WHERE user_id = @user_id
    ORDER BY date DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_or_create_daily_log
    @user_id INT,
    @date    DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = @user_id)
        THROW 50001, 'User does not exist.', 1;

    IF EXISTS (SELECT 1 FROM daily_logs WHERE user_id = @user_id AND date = @date)
    BEGIN
        SELECT log_id FROM daily_logs WHERE user_id = @user_id AND date = @date;
        RETURN;
    END;

    DECLARE @new_id INT = (SELECT ISNULL(MAX(log_id), 0) + 1 FROM daily_logs);
    INSERT INTO daily_logs (log_id, date, user_id) VALUES (@new_id, @date, @user_id);
    SELECT @new_id AS log_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_record_progress_auto
    @user_id INT,
    @date    DATE,
    @weight  FLOAT,
    @notes   VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = @user_id)
        THROW 50006, 'User does not exist.', 1;

    IF EXISTS (SELECT 1 FROM progress WHERE user_id = @user_id AND date = @date)
        THROW 50007, 'You already recorded your weight for today.', 1;

    DECLARE @new_id INT = (SELECT ISNULL(MAX(progress_id), 0) + 1 FROM progress);

    INSERT INTO progress (progress_id, date, weight, notes, user_id)
    VALUES (@new_id, @date, @weight, @notes, @user_id);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_subscribe_user
    @user_id              INT,
    @subscription_plan_id INT,
    @payment_method       VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @duration INT, @price DECIMAL(10, 2);
    DECLARE @today DATE = CAST(GETDATE() AS DATE);

    SELECT @duration = duration_days, @price = price
    FROM subscription_plans
    WHERE subscription_plan_id = @subscription_plan_id;

    IF @duration IS NULL
        THROW 50040, 'Subscription plan does not exist.', 1;

    DECLARE @end_date DATE = DATEADD(day, @duration - 1, @today);
    DECLARE @sub_id   INT  = (SELECT ISNULL(MAX(subscription_id), 0) + 1 FROM user_subscriptions);
    DECLARE @pay_id   INT  = (SELECT ISNULL(MAX(payment_id),      0) + 1 FROM payments);

    INSERT INTO user_subscriptions (subscription_id, start_date, end_date, status, user_id, subscription_plan_id)
    VALUES (@sub_id, @today, @end_date, 'pending', @user_id, @subscription_plan_id);

    INSERT INTO payments (payment_id, amount, payment_date, payment_method, status, subscription_id)
    VALUES (@pay_id, @price, @today, @payment_method, 'completed', @sub_id);
END;
GO
