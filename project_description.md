# Nutrition and Diet Tracking Platform

## 1. Project Overview:
This project aims to develop a database system for a nutrition and diet tracking platform that supports users in managing their dietary habits and improving their overall health. The system allows users to record their daily food intake by selecting foods from a database containing detailed nutritional information, including calories, proteins, carbohydrates, and fats.

The platform enables users to monitor their nutritional consumption over time and compare it with their personal health goals, such as weight loss, muscle gain, or maintenance. Additionally, users can track their physical progress by recording metrics such as weight and other relevant indicators.

A key feature of the system is the support for nutritionists, who can create personalized diet plans tailored to individual users. These plans include structured meal schedules and recommended food quantities, helping users follow a balanced and goal-oriented diet.

The system also incorporates a subscription model, where users can access different levels of functionality depending on their plan. For example, basic users may have limited tracking features, while premium users can access advanced tools such as personalized diet plans and professional support.

Overall, the platform provides a comprehensive solution for diet management, nutritional analysis, and progress tracking, supported by a structured relational database that ensures efficient storage, consistency, and retrieval of data.

## 2. Functional Requirements:

### User Management:
- Users can register and log into the system
- Users can update their personal information (weight, height, goals)

### Meal & Nutrition Tracking:
- Users can record daily meals
- Users can select foods from a database
- The system stores nutritional values (calories, protein, carbs, fat)
- Users can view their daily nutritional intake

### Diet Plans:
- Nutritionists can create diet plans
- Diet plans include meals and food quantities
- Nutritionists can assign diet plans to users
- Users can view their assigned diet plans

### Progress Tracking:
- Users can record their weight over time
- Users can view progress history

### Subscription System:
- The system provides different subscription plans (e.g., Free, Premium, Pro)
- Users can subscribe to a plan
- Users can upgrade or cancel their subscription
- Subscription determines access to features

### Payment System:
- Users can make payments for subscriptions
- The system records payment details (amount, date, method, status)
- Each payment is associated with a user and a subscription
- The system maintains a history of all payments

## 3. Non-Functional Requirements
- The system must ensure data consistency and integrity
- The system must provide secure authentication for users
- The system should be efficient in storing and retrieving data
- The database should support multiple users simultaneously (scalability)

## 4. Entities and Attributes:

### User:
- user_id (PK)
- name
- email
- password
- age
- gender
- height
- weight

### Nutritionist:
- nutritionist_id (PK)
- name
- email
- specialization
- years_experience

### Meals:
- meal_id (PK)
- name (Breakfast, Lunch, etc.)
- quantity

### Foods:
- food_id (PK)
- name
- calories_per_100g
- protein
- carbs
- fat

### Daily_log:
- log_id (PK)
- date
- user_id (FK)

### Diet_plans:
- plan_id (PK)
- name
- description
- nutritionist_id (FK)

### Plan_schedules:
- schedule_id (PK)
- day_of_week
- plan_id (FK)
- meal_id (FK)

### Progress:
- progress_id (PK)
- date
- weight
- notes
- user_id (FK)

### Subscription_plans:
- subscription_plan_id (PK)
- name (Free, Premium, Pro)
- price
- duration_days
- features

### Payments:
- payment_id (PK)
- amount
- payment_date
- payment_method
- status
- user_id (FK)
- subscription_id (FK)

## 5. Relationships:

### Core Relationships:
- LOGS: USER (1) → DAILY_LOG (N)
- CONTAINS: DAILY_LOG (N) ↔ MEAL (N) ↔ FOOD (N) — represents daily food intake entries
- TRACKS: USER (1) → PROGRESS (N)
- SUBSCRIBES: USER (N) → USER_SUBSCRIPTIONS (N)
- GENERATES: USER_SUBSCRIPTIONS (1) → PAYMENTS (N)
- MAKES: USER (1) → PAYMENTS (N)

### Diet Plans:
- CREATES: NUTRITIONIST (1) → DIET_PLAN (N)
- HAS_SCHEDULE: DIET_PLAN (1) → PLAN_SCHEDULE (N)
- IN_SCHEDULE: MEAL (1) → PLAN_SCHEDULE (N)
- FOOD_IN: FOOD (1) → PLAN_SCHEDULE (N)
- HAS_PLAN: USER (N) ↔ DIET_PLAN (N) — with attributes: start_date, end_date

### Subscriptions & Payments:
- PLAN_SUB: SUBSCRIPTION_PLAN (1) → USER_SUBSCRIPTIONS (N)
- SUBSCRIBES: USER (N) → USER_SUBSCRIPTIONS (N)
- GENERATES: USER_SUBSCRIPTIONS (1) → PAYMENTS (N)
- MAKES: USER (1) → PAYMENTS (N)

## 6. ER diagram:
[ER Diagram Image Placeholder]

## 7. Relational Schema:
```
USERS(user_id PK, name, email, password, age, gender, height, weight)

NUTRITIONISTS(nutritionist_id PK, name, email, specialization, years_experience)

MEALS(meal_id PK, name, quantity)

FOODS(food_id PK, name, calories_per_100g, protein, carbs, fat)

DAILY_LOG(log_id PK, user_id FK, date)

CONTAINS(log_id FK, meal_id FK, food_id FK)

DIET_PLANS(plan_id PK, name, description, nutritionist_id FK)

PLAN_SCHEDULE(schedule_id PK, plan_id FK, meal_id FK, day_of_week)

FOOD_IN(schedule_id FK, food_id FK)

HAS_PLAN(user_id FK, plan_id FK, start_date, end_date)

PROGRESS(progress_id PK, user_id FK, date, weight, notes)

SUBSCRIPTION_PLANS(subscription_plan_id PK, name, price, duration_days, features)

USER_SUBSCRIPTIONS(subscription_id PK, user_id FK, subscription_plan_id FK, start_date, end_date, status)

PAYMENTS(payment_id PK, user_id FK, subscription_id FK, amount, payment_date, payment_method, status)
```