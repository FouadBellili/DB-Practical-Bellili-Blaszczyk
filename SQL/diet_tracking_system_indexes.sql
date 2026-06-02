USE p4g7;
GO

CREATE INDEX ix_diet_plans_nutritionist_id
ON diet_plans (nutritionist_id);
GO

CREATE INDEX ix_meals_food_id
ON meals (food_id);
GO

CREATE INDEX ix_plan_schedules_diet_plan_id
ON plan_schedules (diet_plan_id);
GO

CREATE INDEX ix_user_diet_plans_diet_plan_id
ON user_diet_plans (diet_plan_id);
GO

CREATE UNIQUE INDEX ux_progress_user_id_date
ON progress (user_id, date);
GO

CREATE UNIQUE INDEX ux_daily_logs_user_id_date
ON daily_logs (user_id, date);
GO

CREATE INDEX ix_log_meals_meal_id
ON log_meals (meal_id);
GO

CREATE INDEX ix_user_subscriptions_user_id_status_dates
ON user_subscriptions (user_id, status, start_date, end_date);
GO

CREATE INDEX ix_user_subscriptions_plan_id
ON user_subscriptions (subscription_plan_id);
GO

CREATE INDEX ix_payments_subscription_id_status
ON payments (subscription_id, status);
GO
