using System.Data;
using Microsoft.Data.SqlClient;

namespace DietTracker;

internal static class DatabaseHelper
{
    // ============================================================
    // CHANGE THIS — replace with your university server credentials
    // Server   : your SQL Server address (e.g. 192.168.1.1\SQLEXPRESS)
    // Database : p4g7
    // User Id  : your username
    // Password : your password
    // ============================================================
    private const string ConnectionString =
        "Server=192.168.182.10;Database=p4g7;User Id=p4g7;Password=123456789;TrustServerCertificate=True;";

    private static SqlConnection OpenConnection()
    {
        var conn = new SqlConnection(ConnectionString);
        conn.Open();
        return conn;
    }

    private static DataTable RunProcedure(string name, params SqlParameter[] parameters)
    {
        using var conn = OpenConnection();
        using var cmd  = new SqlCommand(name, conn) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.AddRange(parameters);
        var table = new DataTable();
        new SqlDataAdapter(cmd).Fill(table);
        return table;
    }

    private static void RunProcedureNoResult(string name, params SqlParameter[] parameters)
    {
        using var conn = OpenConnection();
        using var cmd  = new SqlCommand(name, conn) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.AddRange(parameters);
        cmd.ExecuteNonQuery();
    }

    // --- Authentication ---

    public static DataRow? LoginUser(string email, string password)
    {
        var t = RunProcedure("sp_login_user",
            new SqlParameter("@email",    email),
            new SqlParameter("@password", password));
        return t.Rows.Count > 0 ? t.Rows[0] : null;
    }

    public static int RegisterUser(string name, string email, string password,
        int age, string gender, double height, double weight, string goal)
    {
        var t = RunProcedure("sp_register_user",
            new SqlParameter("@user_name", name),
            new SqlParameter("@email",     email),
            new SqlParameter("@password",  password),
            new SqlParameter("@age",       age),
            new SqlParameter("@gender",    gender),
            new SqlParameter("@height",    height),
            new SqlParameter("@weight",    weight),
            new SqlParameter("@goal",      goal));
        return (int)t.Rows[0]["user_id"];
    }

    // --- Dashboard ---

    public static DataRow? GetUserDailySummary(int userId, DateTime date)
    {
        var t = RunProcedure("sp_get_user_daily_summary",
            new SqlParameter("@user_id", userId),
            new SqlParameter("@date",    date.Date));
        return t.Rows.Count > 0 ? t.Rows[0] : null;
    }

    public static DataRow? GetUserProfile(int userId)
    {
        var t = RunProcedure("sp_get_user_profile",
            new SqlParameter("@user_id", userId));
        return t.Rows.Count > 0 ? t.Rows[0] : null;
    }

    // --- Meals / Daily Log ---

    public static DataTable GetAllMeals() => RunProcedure("sp_get_all_meals");

    public static int GetOrCreateDailyLog(int userId, DateTime date)
    {
        var t = RunProcedure("sp_get_or_create_daily_log",
            new SqlParameter("@user_id", userId),
            new SqlParameter("@date",    date.Date));
        return (int)t.Rows[0]["log_id"];
    }

    public static void AddMealToLog(int logId, int mealId)
        => RunProcedureNoResult("sp_add_meal_to_log",
            new SqlParameter("@log_id",  logId),
            new SqlParameter("@meal_id", mealId));

    // --- Progress ---

    public static void RecordProgress(int userId, DateTime date, double weight, string? notes)
        => RunProcedureNoResult("sp_record_progress_auto",
            new SqlParameter("@user_id", userId),
            new SqlParameter("@date",    date.Date),
            new SqlParameter("@weight",  weight),
            new SqlParameter("@notes",   (object?)notes ?? DBNull.Value));

    public static DataTable GetUserProgressHistory(int userId)
        => RunProcedure("sp_get_user_progress_history",
            new SqlParameter("@user_id", userId));

    // --- Diet Plans ---

    public static DataTable GetAllDietPlans() => RunProcedure("sp_get_all_diet_plans");

    public static void AssignDietPlan(int userId, int planId, DateTime start, DateTime end)
        => RunProcedureNoResult("sp_assign_diet_plan",
            new SqlParameter("@user_id",      userId),
            new SqlParameter("@diet_plan_id", planId),
            new SqlParameter("@start_date",   start.Date),
            new SqlParameter("@end_date",     end.Date));

    // --- Subscriptions ---

    public static DataTable GetAllSubscriptionPlans()
        => RunProcedure("sp_get_all_subscription_plans");

    public static void SubscribeUser(int userId, int planId, string paymentMethod)
        => RunProcedureNoResult("sp_subscribe_user",
            new SqlParameter("@user_id",              userId),
            new SqlParameter("@subscription_plan_id", planId),
            new SqlParameter("@payment_method",       paymentMethod));
}
