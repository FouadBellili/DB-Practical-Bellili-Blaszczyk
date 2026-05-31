using System.Drawing;
using System.Windows.Forms;

namespace DietTracker;

public class FormDashboard : Form
{
    private readonly Label _lblGreeting    = new() { AutoSize = true };
    private readonly Label _lblCalories    = new() { AutoSize = true };
    private readonly Label _lblBmi         = new() { AutoSize = true };
    private readonly Label _lblSubscription = new() { AutoSize = true };

    public FormDashboard()
    {
        Text            = "Diet Tracker — Dashboard";
        ClientSize      = new Size(480, 540);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox     = false;
        BackColor       = Color.White;
        Font            = new Font("Segoe UI", 12);

        // Header
        var header = new Panel
        {
            BackColor = Color.FromArgb(39, 174, 96),
            Location  = new Point(0, 0),
            Width     = 480,
            Height    = 100
        };
        _lblGreeting.Font      = new Font("Segoe UI", 18, FontStyle.Bold);
        _lblGreeting.ForeColor = Color.White;
        _lblGreeting.Location  = new Point(24, 18);
        var lblSub = new Label
        {
            Text      = "Here is your summary for today",
            Font      = new Font("Segoe UI", 11),
            ForeColor = Color.FromArgb(200, 255, 200),
            AutoSize  = true,
            Location  = new Point(24, 58)
        };
        header.Controls.AddRange(new Control[] { _lblGreeting, lblSub });
        Controls.Add(header);

        // Stats card
        var card = new Panel
        {
            BackColor = Color.FromArgb(240, 250, 240),
            Location  = new Point(24, 116),
            Width     = 432,
            Height    = 110,
            BorderStyle = BorderStyle.FixedSingle
        };
        AddStat(card, "Today's Calories", _lblCalories, 24);
        AddStat(card, "BMI",              _lblBmi,      168);
        AddStat(card, "Subscription",     _lblSubscription, 300);
        Controls.Add(card);

        // Navigation buttons
        int btnY = 252;
        AddNavButton("Log a Meal",       btnY,       BtnLogMeal_Click);
        AddNavButton("Record My Weight", btnY + 66,  BtnProgress_Click);
        AddNavButton("My Diet Plan",     btnY + 132, BtnDietPlan_Click);

        // Sign out
        var btnSignOut = new Button
        {
            Text      = "Sign Out",
            Font      = new Font("Segoe UI", 10),
            BackColor = Color.White,
            ForeColor = Color.Gray,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(24, btnY + 210),
            Width     = 432,
            Height    = 36,
            Cursor    = Cursors.Hand
        };
        btnSignOut.FlatAppearance.BorderSize = 0;
        btnSignOut.Click += (s, e) => Close();
        Controls.Add(btnSignOut);

        Load += (s, e) => RefreshSummary();
    }

    private void AddStat(Panel card, string labelText, Label valueLabel, int x)
    {
        card.Controls.Add(new Label
        {
            Text      = labelText,
            Font      = new Font("Segoe UI", 9),
            ForeColor = Color.Gray,
            AutoSize  = true,
            Location  = new Point(x, 14)
        });
        valueLabel.Font      = new Font("Segoe UI", 16, FontStyle.Bold);
        valueLabel.ForeColor = Color.FromArgb(39, 174, 96);
        valueLabel.Location  = new Point(x, 36);
        card.Controls.Add(valueLabel);
    }

    private void AddNavButton(string text, int y, EventHandler handler)
    {
        var btn = new Button
        {
            Text      = text,
            Font      = new Font("Segoe UI", 14, FontStyle.Bold),
            BackColor = Color.FromArgb(39, 174, 96),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(24, y),
            Width     = 432,
            Height    = 54,
            Cursor    = Cursors.Hand
        };
        btn.FlatAppearance.BorderSize = 0;
        btn.Click += handler;
        Controls.Add(btn);
    }

    public void RefreshSummary()
    {
        _lblGreeting.Text = $"Welcome, {Session.UserName}!";

        try
        {
            var row = DatabaseHelper.GetUserDailySummary(Session.UserId, DateTime.Today);
            if (row != null)
            {
                _lblCalories.Text     = $"{row["total_calories"]} kcal";
                _lblBmi.Text          = $"{row["current_bmi"]}";
                _lblSubscription.Text = Convert.ToBoolean(row["has_active_subscription"]) ? "Active" : "None";
            }
        }
        catch
        {
            _lblCalories.Text = _lblBmi.Text = _lblSubscription.Text = "—";
        }
    }

    private void BtnLogMeal_Click(object? sender, EventArgs e)
    {
        new FormLogMeal().ShowDialog(this);
        RefreshSummary();
    }

    private void BtnProgress_Click(object? sender, EventArgs e)
    {
        new FormProgress().ShowDialog(this);
        RefreshSummary();
    }

    private void BtnDietPlan_Click(object? sender, EventArgs e)
    {
        new FormDietPlan().ShowDialog(this);
    }
}
