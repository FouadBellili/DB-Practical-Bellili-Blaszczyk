USE p4g7;
GO

CREATE OR ALTER FUNCTION dbo.fn_calculate_meal_calories
(
    @meal_id INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @calories DECIMAL(10, 2);

    SELECT @calories = CAST((m.quantity * f.calories_per_100g) / 100.0 AS DECIMAL(10, 2))
    FROM meals AS m
    INNER JOIN foods AS f ON f.food_id = m.food_id
    WHERE m.meal_id = @meal_id;

    RETURN ISNULL(@calories, 0);
END;
GO

CREATE OR ALTER FUNCTION dbo.fn_calculate_daily_log_calories
(
    @log_id INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total_calories DECIMAL(10, 2);

    SELECT @total_calories = CAST(SUM((m.quantity * f.calories_per_100g) / 100.0) AS DECIMAL(10, 2))
    FROM log_meals AS lm
    INNER JOIN meals AS m ON m.meal_id = lm.meal_id
    INNER JOIN foods AS f ON f.food_id = m.food_id
    WHERE lm.log_id = @log_id;

    RETURN ISNULL(@total_calories, 0);
END;
GO

CREATE OR ALTER FUNCTION dbo.fn_calculate_user_bmi
(
    @user_id INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @bmi DECIMAL(10, 2);

    SELECT @bmi = CAST(weight / POWER(height / 100.0, 2) AS DECIMAL(10, 2))
    FROM users
    WHERE user_id = @user_id;

    RETURN ISNULL(@bmi, 0);
END;
GO

CREATE OR ALTER FUNCTION dbo.fn_user_has_active_subscription
(
    @user_id INT,
    @check_date DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @has_active_subscription BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM user_subscriptions
        WHERE user_id = @user_id
          AND status = 'active'
          AND @check_date BETWEEN start_date AND end_date
    )
    BEGIN
        SET @has_active_subscription = 1;
    END;

    RETURN @has_active_subscription;
END;
GO
