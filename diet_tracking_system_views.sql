USE p4g7;
GO

CREATE OR ALTER VIEW dbo.vw_user_profile AS
SELECT
    u.user_id,
    u.user_name,
    u.email,
    u.age,
    u.gender,
    u.height,
    u.weight,
    u.goal,
    sp.subscription_name,
    sp.price         AS subscription_price,
    sp.duration_days AS subscription_duration,
    us.start_date    AS subscription_start,
    us.end_date      AS subscription_end,
    us.status        AS subscription_status
FROM users u
LEFT JOIN user_subscriptions us
       ON u.user_id = us.user_id
      AND us.status = 'active'
LEFT JOIN subscription_plans sp
       ON us.subscription_plan_id = sp.subscription_plan_id;
GO

CREATE OR ALTER VIEW dbo.vw_user_diet_plans AS
SELECT
    u.user_id,
    u.user_name,
    u.email,
    dp.diet_plan_id,
    dp.plan_name,
    dp.description,
    udp.start_date,
    udp.end_date,
    n.nutritionist_id,
    n.nutritionist_name,
    n.email              AS nutritionist_email,
    n.specialization,
    n.years_of_experience
FROM users u
JOIN user_diet_plans udp  ON u.user_id        = udp.user_id
JOIN diet_plans dp        ON udp.diet_plan_id  = dp.diet_plan_id
LEFT JOIN nutritionists n ON dp.nutritionist_id = n.nutritionist_id;
GO

CREATE OR ALTER VIEW dbo.vw_diet_plan_schedule AS
SELECT
    dp.diet_plan_id,
    dp.plan_name,
    ps.schedule_id,
    ps.day_of_week,
    m.meal_id,
    m.meal_name,
    m.quantity,
    f.food_id,
    f.food_name,
    f.calories_per_100g,
    ROUND((m.quantity / 100.0) * f.calories_per_100g, 2) AS total_calories
FROM diet_plans dp
JOIN plan_schedules ps       ON dp.diet_plan_id = ps.diet_plan_id
JOIN plan_schedule_meals psm ON ps.schedule_id  = psm.schedule_id
JOIN meals m                 ON psm.meal_id      = m.meal_id
JOIN foods f                 ON m.food_id        = f.food_id;
GO

CREATE OR ALTER VIEW dbo.vw_user_daily_food_log AS
SELECT
    u.user_id,
    u.user_name,
    dl.log_id,
    dl.date          AS log_date,
    m.meal_id,
    m.meal_name,
    m.quantity,
    f.food_name,
    f.calories_per_100g,
    ROUND((m.quantity / 100.0) * f.calories_per_100g, 2) AS calories_consumed
FROM users u
JOIN daily_logs dl ON u.user_id  = dl.user_id
JOIN log_meals lm  ON dl.log_id  = lm.log_id
JOIN meals m       ON lm.meal_id = m.meal_id
JOIN foods f       ON m.food_id  = f.food_id;
GO

CREATE OR ALTER VIEW dbo.vw_user_daily_calories AS
SELECT
    user_id,
    user_name,
    log_date,
    COUNT(DISTINCT meal_id)               AS total_meals,
    ROUND(SUM(calories_consumed), 2)      AS total_calories
FROM dbo.vw_user_daily_food_log
GROUP BY user_id, user_name, log_date;
GO

CREATE OR ALTER VIEW dbo.vw_user_progress AS
SELECT
    u.user_id,
    u.user_name,
    u.goal,
    u.weight         AS current_weight,
    p.progress_id,
    p.date           AS recorded_date,
    p.weight         AS recorded_weight,
    p.notes,
    ROUND(p.weight - u.weight, 2) AS weight_change_from_current
FROM users u
JOIN progress p ON u.user_id = p.user_id;
GO

CREATE OR ALTER VIEW dbo.vw_payment_subscription_history AS
SELECT
    u.user_id,
    u.user_name,
    us.subscription_id,
    us.start_date,
    us.end_date,
    us.status        AS subscription_status,
    sp.subscription_name,
    sp.price,
    p.payment_id,
    p.payment_date,
    p.amount,
    p.payment_method,
    p.status         AS payment_status
FROM users u
JOIN user_subscriptions us  ON u.user_id              = us.user_id
JOIN subscription_plans sp  ON us.subscription_plan_id = sp.subscription_plan_id
LEFT JOIN payments p        ON us.subscription_id      = p.subscription_id;
GO

CREATE OR ALTER VIEW dbo.vw_nutritionist_workload AS
SELECT
    n.nutritionist_id,
    n.nutritionist_name,
    n.email,
    n.specialization,
    n.years_of_experience,
    COUNT(DISTINCT dp.diet_plan_id) AS total_plans,
    COUNT(DISTINCT udp.user_id)     AS total_active_users
FROM nutritionists n
LEFT JOIN diet_plans dp       ON n.nutritionist_id  = dp.nutritionist_id
LEFT JOIN user_diet_plans udp ON dp.diet_plan_id    = udp.diet_plan_id
GROUP BY
    n.nutritionist_id,
    n.nutritionist_name,
    n.email,
    n.specialization,
    n.years_of_experience;
GO
