USE p4g7;

CREATE TABLE nutritionists (
    nutritionist_id INT PRIMARY KEY,
    nutritionist_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    specialization VARCHAR(255) NOT NULL,
    years_of_experience INT NOT NULL
);

CREATE TABLE foods (
    food_id INT PRIMARY KEY,
    food_name VARCHAR(255) NOT NULL,
    calories_per_100g INT NOT NULL,
    protein_per_100g FLOAT NOT NULL,
    carbs_per_100g FLOAT NOT NULL,
    fat_per_100g FLOAT NOT NULL
);

CREATE TABLE subscription_plans (
    subscription_plan_id INT PRIMARY KEY,
    subscription_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL,
    features VARCHAR(255) NOT NULL
);

CREATE TABLE diet_plans (
    diet_plan_id INT PRIMARY KEY,
    plan_name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    nutritionist_id INT NOT NULL,
    FOREIGN KEY (nutritionist_id) REFERENCES nutritionists(nutritionist_id)
);

CREATE TABLE meals (
    meal_id INT PRIMARY KEY,
    meal_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    food_id INT NOT NULL,
    FOREIGN KEY (food_id) REFERENCES foods(food_id)
);

CREATE TABLE plan_schedules (
    schedule_id INT PRIMARY KEY,
    day_of_week VARCHAR(20) NOT NULL,
    diet_plan_id INT NOT NULL,
    FOREIGN KEY (diet_plan_id) REFERENCES diet_plans(diet_plan_id)
);

CREATE TABLE plan_schedule_meals (
    schedule_id INT NOT NULL,
    meal_id INT NOT NULL,
    PRIMARY KEY (schedule_id, meal_id),
    FOREIGN KEY (schedule_id) REFERENCES plan_schedules(schedule_id),
    FOREIGN KEY (meal_id) REFERENCES meals(meal_id)
);

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(20) NOT NULL,
    height FLOAT NOT NULL,
    weight FLOAT NOT NULL,
    goal VARCHAR(255) NOT NULL
);

CREATE TABLE user_diet_plans (
    user_id INT NOT NULL,
    diet_plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    PRIMARY KEY (user_id, diet_plan_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (diet_plan_id) REFERENCES diet_plans(diet_plan_id)
);

CREATE TABLE progress (
    progress_id INT PRIMARY KEY,
    date DATE NOT NULL,
    weight FLOAT NOT NULL,
    notes VARCHAR(255),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE daily_logs (
    log_id INT PRIMARY KEY,
    date DATE NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE log_meals (
    log_id INT NOT NULL,
    meal_id INT NOT NULL,
    PRIMARY KEY (log_id, meal_id),
    FOREIGN KEY (log_id) REFERENCES daily_logs(log_id),
    FOREIGN KEY (meal_id) REFERENCES meals(meal_id)
);

CREATE TABLE user_subscriptions (
    subscription_id INT PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    subscription_plan_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (subscription_plan_id) REFERENCES subscription_plans(subscription_plan_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    subscription_id INT NOT NULL,
    FOREIGN KEY (subscription_id) REFERENCES user_subscriptions(subscription_id)
);