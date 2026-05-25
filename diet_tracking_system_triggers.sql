USE p4g7;
GO

CREATE OR ALTER TRIGGER dbo.trg_payments_set_subscription_status
ON payments
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE us
    SET status = 'active'
    FROM user_subscriptions AS us
    INNER JOIN inserted AS i ON i.subscription_id = us.subscription_id
    WHERE i.status = 'completed'
      AND i.payment_date BETWEEN us.start_date AND us.end_date
      AND us.status IN ('pending', 'expired');
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_progress_update_user_weight
ON progress
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE u
    SET weight = latest_progress.weight
    FROM users AS u
    INNER JOIN (
        SELECT i.user_id, i.weight
        FROM inserted AS i
        WHERE i.date = (
            SELECT MAX(p.date)
            FROM progress AS p
            WHERE p.user_id = i.user_id
        )
    ) AS latest_progress ON latest_progress.user_id = u.user_id;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_daily_logs_one_per_user_date
ON daily_logs
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM daily_logs AS dl
        INNER JOIN inserted AS i
            ON i.user_id = dl.user_id
           AND i.date = dl.date
           AND i.log_id <> dl.log_id
    )
    BEGIN
        THROW 50020, 'Only one daily log is allowed per user and date.', 1;
    END;
END;
GO
