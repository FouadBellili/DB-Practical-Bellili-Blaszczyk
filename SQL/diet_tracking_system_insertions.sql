USE p4g7;
GO

INSERT INTO nutritionists (nutritionist_id, nutritionist_name, email, specialization, years_of_experience) VALUES
(1, 'Sofia Martins',    'sofia.martins@nutrition.pt',    'Sports Nutrition',    12),
(2, 'Pedro Alves',      'pedro.alves@nutrition.pt',      'Weight Management',    8),
(3, 'Ana Costa',        'ana.costa@nutrition.pt',        'Clinical Nutrition',  15),
(4, 'Rui Fernandes',    'rui.fernandes@nutrition.pt',    'Pediatric Nutrition',  5),
(5, 'Carla Sousa',      'carla.sousa@nutrition.pt',      'Vegan & Plant-Based',  9);
GO

INSERT INTO foods (food_id, food_name, calories_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
(1,  'Chicken Breast',    165, 31.0,  0.0,   3.6),
(2,  'Brown Rice',        216,  5.0, 45.0,   1.8),
(3,  'Broccoli',           34,  2.8,  6.6,   0.4),
(4,  'Whole Egg',         155, 13.0,  1.1,  11.0),
(5,  'Oats',              389, 17.0, 66.0,   7.0),
(6,  'Salmon',            208, 20.0,  0.0,  13.0),
(7,  'Sweet Potato',       86,  1.6, 20.0,   0.1),
(8,  'Greek Yogurt',       59, 10.0,  3.6,   0.4),
(9,  'Banana',             89,  1.1, 23.0,   0.3),
(10, 'Almonds',           579, 21.0, 22.0,  50.0),
(11, 'Spinach',            23,  2.9,  3.6,   0.4),
(12, 'Olive Oil',         884,  0.0,  0.0, 100.0),
(13, 'Quinoa',            368, 14.0, 64.0,   6.0),
(14, 'Tuna (canned)',     116, 26.0,  0.0,   1.0),
(15, 'Whole Wheat Bread', 247,  9.0, 48.0,   3.4);
GO

INSERT INTO subscription_plans (subscription_plan_id, subscription_name, price, duration_days, features) VALUES
(1, 'Free',        0.00,  30, 'Basic calorie tracking, 1 diet plan'),
(2, 'Basic',       4.99,  30, 'Full tracking, 3 diet plans, progress charts'),
(3, 'Premium',     9.99,  30, 'Unlimited plans, nutritionist chat, detailed reports'),
(4, 'Annual Pro', 79.99, 365, 'All Premium features, priority support, export data');
GO

INSERT INTO diet_plans (diet_plan_id, plan_name, description, nutritionist_id) VALUES
(1, 'Weight Loss Starter',    'Low-calorie plan focused on lean proteins and vegetables',         2),
(2, 'Muscle Gain',            'High-protein plan with complex carbohydrates for muscle building', 1),
(3, 'Balanced Mediterranean', 'Heart-healthy plan inspired by Mediterranean cuisine',             3),
(4, 'Plant-Based Detox',      '7-day plant-based cleanse with antioxidant-rich foods',           5),
(5, 'Diabetic Friendly',      'Low-glycaemic-index plan with controlled carbohydrate intake',    3),
(6, 'Athlete Performance',    'High-calorie, high-carb plan designed for endurance athletes',    1);
GO

INSERT INTO meals (meal_id, meal_name, quantity, food_id) VALUES
(1,  'Grilled Chicken Portion', 200, 1),
(2,  'Brown Rice Serving',      150, 2),
(3,  'Steamed Broccoli',        200, 3),
(4,  'Boiled Eggs (2)',         120, 4),
(5,  'Morning Oats Bowl',       100, 5),
(6,  'Baked Salmon Fillet',     180, 6),
(7,  'Roasted Sweet Potato',    200, 7),
(8,  'Greek Yogurt Cup',        150, 8),
(9,  'Banana Snack',            120, 9),
(10, 'Almond Handful',           30, 10),
(11, 'Spinach Salad Base',      100, 11),
(12, 'Tuna Salad',              150, 14),
(13, 'Quinoa Bowl',             180, 13),
(14, 'Whole Wheat Toast (2)',   100, 15),
(15, 'Salmon with Spinach',     200, 6);
GO

INSERT INTO plan_schedules (schedule_id, day_of_week, diet_plan_id) VALUES
(1,  'Monday',    1),
(2,  'Tuesday',   1),
(3,  'Wednesday', 1),
(4,  'Thursday',  1),
(5,  'Friday',    1),
(6,  'Monday',    2),
(7,  'Tuesday',   2),
(8,  'Wednesday', 2),
(9,  'Monday',    3),
(10, 'Tuesday',   3),
(11, 'Wednesday', 3),
(12, 'Thursday',  3),
(13, 'Friday',    3),
(14, 'Saturday',  3),
(15, 'Sunday',    3);
GO

INSERT INTO plan_schedule_meals (schedule_id, meal_id) VALUES
(1, 5), (1, 1), (1, 3),
(2, 8), (2, 12), (2, 7),
(3, 4), (3, 11), (3, 2),
(4, 5), (4, 6), (4, 3),
(5, 8), (5, 1), (5, 13),
(6, 5), (6, 4), (6, 1), (6, 2),
(7, 14), (7, 6), (7, 13),
(8, 5), (8, 1), (8, 7),
(9, 6), (9, 11), (9, 2),
(10, 15), (10, 13),
(11, 12), (11, 11), (11, 7),
(12, 4), (12, 14), (12, 3),
(13, 6), (13, 13),
(14, 8), (14, 9), (14, 10),
(15, 1), (15, 3), (15, 2);
GO

INSERT INTO users (user_id, user_name, email, password, age, gender, height, weight, goal) VALUES
(1, 'joao_silva',     'joao.silva@email.com',     'hashed_pw_001', 28, 'Male',   178.0, 82.0, 'Lose weight'),
(2, 'maria_santos',   'maria.santos@email.com',   'hashed_pw_002', 34, 'Female', 165.0, 68.0, 'Maintain weight'),
(3, 'carlos_pereira', 'carlos.pereira@email.com', 'hashed_pw_003', 22, 'Male',   182.0, 75.0, 'Gain muscle'),
(4, 'luisa_ferreira', 'luisa.ferreira@email.com', 'hashed_pw_004', 45, 'Female', 160.0, 72.0, 'Improve health'),
(5, 'miguel_costa',   'miguel.costa@email.com',   'hashed_pw_005', 30, 'Male',   175.0, 90.0, 'Lose weight'),
(6, 'sara_oliveira',  'sara.oliveira@email.com',  'hashed_pw_006', 26, 'Female', 168.0, 61.0, 'Gain muscle'),
(7, 'tiago_gomes',    'tiago.gomes@email.com',    'hashed_pw_007', 38, 'Male',   171.0, 85.0, 'Lose weight'),
(8, 'ines_rocha',     'ines.rocha@email.com',     'hashed_pw_008', 29, 'Female', 163.0, 58.0, 'Maintain weight');
GO

INSERT INTO user_subscriptions (subscription_id, start_date, end_date, status, user_id, subscription_plan_id) VALUES
(1,  '2026-01-01', '2026-01-31', 'expired', 1, 2),
(2,  '2026-02-01', '2026-02-28', 'expired', 1, 2),
(3,  '2026-03-01', '2026-03-31', 'active',  1, 3),
(4,  '2026-02-15', '2026-03-16', 'active',  2, 2),
(5,  '2026-03-01', '2026-03-31', 'active',  3, 3),
(6,  '2025-06-01', '2026-05-31', 'active',  4, 4),
(7,  '2026-03-01', '2026-03-31', 'pending', 5, 2),
(8,  '2026-03-01', '2026-03-31', 'active',  6, 2),
(9,  '2026-01-01', '2026-01-31', 'expired', 7, 1),
(10, '2026-03-01', '2026-03-31', 'active',  8, 3);
GO

INSERT INTO payments (payment_id, amount, payment_date, payment_method, status, subscription_id) VALUES
(1,  4.99,  '2026-01-01', 'Credit Card',   'completed', 1),
(2,  4.99,  '2026-02-01', 'Credit Card',   'completed', 2),
(3,  9.99,  '2026-03-01', 'PayPal',        'completed', 3),
(4,  4.99,  '2026-02-15', 'Credit Card',   'completed', 4),
(5,  9.99,  '2026-03-01', 'MB Way',        'completed', 5),
(6,  79.99, '2025-06-01', 'Bank Transfer', 'completed', 6),
(7,  9.99,  '2026-03-01', 'Credit Card',   'completed', 10),
(8,  4.99,  '2026-03-01', 'MB Way',        'completed', 8);
GO

INSERT INTO user_diet_plans (user_id, diet_plan_id, start_date, end_date) VALUES
(1, 1, '2026-03-01', '2026-03-31'),
(2, 3, '2026-02-15', '2026-03-16'),
(3, 2, '2026-03-01', '2026-03-31'),
(4, 5, '2025-06-01', '2026-05-31'),
(5, 1, '2026-03-10', '2026-03-31'),
(6, 2, '2026-03-01', '2026-03-31'),
(7, 1, '2026-01-01', '2026-01-31'),
(8, 3, '2026-03-01', '2026-03-31');
GO

INSERT INTO progress (progress_id, date, weight, notes, user_id) VALUES
(1,  '2026-03-01', 82.0, 'Starting weight',              1),
(2,  '2026-03-08', 81.2, 'First week - going well',      1),
(3,  '2026-03-15', 80.5, 'Lost 1.5kg so far',            1),
(4,  '2026-03-22', 79.8, 'Feeling more energetic',       1),
(5,  '2026-03-01', 68.0, 'Starting weight',              2),
(6,  '2026-03-08', 67.8, 'Slight decrease',              2),
(7,  '2026-03-01', 75.0, 'Starting muscle gain program', 3),
(8,  '2026-03-08', 75.4, '+0.4kg lean mass',             3),
(9,  '2026-03-15', 75.9, 'Good progress',                3),
(10, '2026-03-01', 90.0, 'Starting weight',              5),
(11, '2026-03-10', 89.1, '-0.9kg first week',            5),
(12, '2026-03-01', 61.0, 'Baseline',                     6),
(13, '2026-03-08', 61.3, '+0.3kg muscle',                6),
(14, '2026-03-01', 58.0, 'Starting weight',              8),
(15, '2026-03-08', 58.1, 'Stable',                       8);
GO

INSERT INTO daily_logs (log_id, date, user_id) VALUES
(1,  '2026-03-10', 1),
(2,  '2026-03-11', 1),
(3,  '2026-03-12', 1),
(4,  '2026-03-10', 2),
(5,  '2026-03-11', 2),
(6,  '2026-03-10', 3),
(7,  '2026-03-11', 3),
(8,  '2026-03-10', 5),
(9,  '2026-03-10', 6),
(10, '2026-03-11', 6),
(11, '2026-03-10', 8),
(12, '2026-03-11', 8);
GO

INSERT INTO log_meals (log_id, meal_id) VALUES
(1, 5), (1, 1), (1, 3),
(2, 8), (2, 6), (2, 2),
(3, 4), (3, 12), (3, 7),
(4, 6), (4, 11), (4, 13),
(5, 8), (5, 15),
(6, 5), (6, 4), (6, 1), (6, 2),
(7, 14), (7, 1), (7, 13),
(8, 5), (8, 1), (8, 3),
(9, 5), (9, 4), (9, 6),
(10, 1), (10, 2), (10, 7),
(11, 6), (11, 13),
(12, 8), (12, 9), (12, 10);
GO
