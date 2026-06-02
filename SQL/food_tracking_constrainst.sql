use p4g7;

-- nutritionists
ALTER TABLE nutritionists
  ADD CONSTRAINT chk_nutritionists_experience CHECK (years_of_experience >= 0);

-- foods
ALTER TABLE foods
  ADD CONSTRAINT uq_foods_name UNIQUE (food_name);
ALTER TABLE foods
  ADD CONSTRAINT chk_foods_calories CHECK (calories_per_100g >= 0);
ALTER TABLE foods
  ADD CONSTRAINT chk_foods_protein CHECK (protein_per_100g >= 0);
ALTER TABLE foods
  ADD CONSTRAINT chk_foods_carbs CHECK (carbs_per_100g >= 0);
ALTER TABLE foods
  ADD CONSTRAINT chk_foods_fat CHECK (fat_per_100g >= 0);

-- subscription_plans
ALTER TABLE subscription_plans
  ADD CONSTRAINT uq_subscription_plans_name UNIQUE (subscription_name);
ALTER TABLE subscription_plans
  ADD CONSTRAINT chk_subscription_plans_price CHECK (price >= 0);
ALTER TABLE subscription_plans
  ADD CONSTRAINT chk_subscription_plans_duration CHECK (duration_days > 0);

-- diet_plans
ALTER TABLE diet_plans
  ADD CONSTRAINT uq_diet_plans_name UNIQUE (plan_name);

-- meals
ALTER TABLE meals
  ADD CONSTRAINT uq_meals_name UNIQUE (meal_name);
ALTER TABLE meals
  ADD CONSTRAINT chk_meals_qty CHECK (quantity > 0);

-- plan_schedules
ALTER TABLE plan_schedules
  ADD CONSTRAINT chk_plan_schedules_day CHECK (
    day_of_week IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
  );

-- users
ALTER TABLE users
  ADD CONSTRAINT uq_users_name UNIQUE (user_name);
ALTER TABLE users
  ADD CONSTRAINT chk_users_age CHECK (age > 0);
ALTER TABLE users
  ADD CONSTRAINT chk_users_height CHECK (height > 0);
ALTER TABLE users
  ADD CONSTRAINT chk_users_weight CHECK (weight > 0);
ALTER TABLE users
  ADD CONSTRAINT chk_users_gender CHECK (gender IN ('Male','Female','Other','Prefer not to say'));

-- user_diet_plans
ALTER TABLE user_diet_plans
  ADD CONSTRAINT chk_udp_dates CHECK (end_date >= start_date);

-- progress
ALTER TABLE progress
  ADD CONSTRAINT chk_progress_weight CHECK (weight > 0);

-- user_subscriptions
ALTER TABLE user_subscriptions
  ADD CONSTRAINT chk_usub_dates CHECK (end_date >= start_date);
ALTER TABLE user_subscriptions
  ADD CONSTRAINT chk_usub_status CHECK (status IN ('active','expired','cancelled','pending'));

-- payments
ALTER TABLE payments
  ADD CONSTRAINT chk_payments_amount CHECK (amount > 0);
ALTER TABLE payments
  ADD CONSTRAINT chk_payments_status CHECK (status IN ('pending','completed','failed','refunded'));