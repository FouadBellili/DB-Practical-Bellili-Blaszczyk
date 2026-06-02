USE p4g7;
GO

CREATE OR ALTER PROCEDURE dbo.sp_create_daily_log
    @log_id INT,
    @user_id INT,
    @date DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = @user_id)
        THROW 50001, 'User does not exist.', 1;

    IF EXISTS (SELECT 1 FROM daily_logs WHERE user_id = @user_id AND date = @date)
        THROW 50002, 'A daily log already exists for this user and date.', 1;

    INSERT INTO daily_logs (log_id, date, user_id)
    VALUES (@log_id, @date, @user_id);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_add_meal_to_log
    @log_id INT,
    @meal_id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM daily_logs WHERE log_id = @log_id)
        THROW 50003, 'Daily log does not exist.', 1;

    IF NOT EXISTS (SELECT 1 FROM meals WHERE meal_id = @meal_id)
        THROW 50004, 'Meal does not exist.', 1;

    IF EXISTS (SELECT 1 FROM log_meals WHERE log_id = @log_id AND meal_id = @meal_id)
        THROW 50005, 'This meal is already assigned to the daily log.', 1;

    INSERT INTO log_meals (log_id, meal_id)
    VALUES (@log_id, @meal_id);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_record_progress
    @progress_id INT,
    @user_id INT,
    @date DATE,
    @weight FLOAT,
    @notes VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = @user_id)
        THROW 50006, 'User does not exist.', 1;

    IF EXISTS (SELECT 1 FROM progress WHERE user_id = @user_id AND date = @date)
        THROW 50007, 'Progress for this user and date already exists.', 1;

    INSERT INTO progress (progress_id, date, weight, notes, user_id)
    VALUES (@progress_id, @date, @weight, @notes, @user_id);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_assign_diet_plan
    @user_id INT,
    @diet_plan_id INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = @user_id)
        THROW 50008, 'User does not exist.', 1;

    IF NOT EXISTS (SELECT 1 FROM diet_plans WHERE diet_plan_id = @diet_plan_id)
        THROW 50009, 'Diet plan does not exist.', 1;

    IF @end_date < @start_date
        THROW 50010, 'End date cannot be earlier than start date.', 1;

    IF EXISTS (
        SELECT 1
        FROM user_diet_plans
        WHERE user_id = @user_id
          AND diet_plan_id = @diet_plan_id
          AND @start_date <= end_date
          AND @end_date >= start_date
    )
        THROW 50011, 'This diet plan overlaps an existing assignment for the user.', 1;

    INSERT INTO user_diet_plans (user_id, diet_plan_id, start_date, end_date)
    VALUES (@user_id, @diet_plan_id, @start_date, @end_date);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_register_payment
    @payment_id INT,
    @subscription_id INT,
    @amount DECIMAL(10, 2),
    @payment_date DATE,
    @payment_method VARCHAR(100),
    @status VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM user_subscriptions WHERE subscription_id = @subscription_id)
        THROW 50012, 'Subscription does not exist.', 1;

    INSERT INTO payments (payment_id, amount, payment_date, payment_method, status, subscription_id)
    VALUES (@payment_id, @amount, @payment_date, @payment_method, @status, @subscription_id);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_user_daily_summary
    @user_id INT,
    @date DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        u.user_id,
        u.user_name,
        dl.log_id,
        dl.date,
        CAST(ISNULL(SUM((m.quantity * f.calories_per_100g) / 100.0), 0) AS DECIMAL(10, 2)) AS total_calories,
        CAST(ISNULL(SUM((m.quantity * f.protein_per_100g) / 100.0), 0) AS DECIMAL(10, 2)) AS total_protein,
        CAST(ISNULL(SUM((m.quantity * f.carbs_per_100g) / 100.0), 0) AS DECIMAL(10, 2)) AS total_carbs,
        CAST(ISNULL(SUM((m.quantity * f.fat_per_100g) / 100.0), 0) AS DECIMAL(10, 2)) AS total_fat,
        dbo.fn_calculate_user_bmi(u.user_id) AS current_bmi,
        dbo.fn_user_has_active_subscription(u.user_id, @date) AS has_active_subscription
    FROM users AS u
    LEFT JOIN daily_logs AS dl ON dl.user_id = u.user_id AND dl.date = @date
    LEFT JOIN log_meals AS lm ON lm.log_id = dl.log_id
    LEFT JOIN meals AS m ON m.meal_id = lm.meal_id
    LEFT JOIN foods AS f ON f.food_id = m.food_id
    WHERE u.user_id = @user_id
    GROUP BY u.user_id, u.user_name, dl.log_id, dl.date;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_update_subscription_statuses
    @check_date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @check_date IS NULL
        SET @check_date = CAST(GETDATE() AS DATE);

    UPDATE user_subscriptions
    SET status = 'expired'
    WHERE end_date < @check_date
      AND status IN ('active', 'pending');

    UPDATE user_subscriptions
    SET status = 'active'
    WHERE @check_date BETWEEN start_date AND end_date
      AND status = 'pending'
      AND EXISTS (
          SELECT 1
          FROM payments
          WHERE payments.subscription_id = user_subscriptions.subscription_id
            AND payments.status = 'completed'
      );
END;
GO
