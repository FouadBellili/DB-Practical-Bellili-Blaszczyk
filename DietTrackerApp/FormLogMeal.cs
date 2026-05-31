using System.Data;
using System.Drawing;
using System.Windows.Forms;

namespace DietTracker;

public class FormLogMeal : Form
{
    private readonly ComboBox _cmbMeals  = new() { Width = 400, DropDownStyle = ComboBoxStyle.DropDownList };
    private readonly Label    _lblCal    = new() { AutoSize = true, ForeColor = Color.FromArgb(39, 174, 96) };
    private readonly ListBox  _lstLogged = new() { Width = 400, Height = 140 };
    private readonly Label    _lblStatus = new() { AutoSize = true };

    private DataTable? _meals;

    public FormLogMeal()
    {
        Text            = "Diet Tracker — Log a Meal";
        ClientSize      = new Size(440, 450);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox     = false;
        BackColor       = Color.White;
        Font            = new Font("Segoe UI", 12);

        Controls.Add(new Label
        {
            Text      = "What did you eat?",
            Font      = new Font("Segoe UI", 20, FontStyle.Bold),
            ForeColor = Color.FromArgb(39, 174, 96),
            AutoSize  = true,
            Location  = new Point(20, 22)
        });

        Controls.Add(new Label { Text = "Choose a meal:", AutoSize = true, Location = new Point(20, 80) });
        _cmbMeals.Location     = new Point(20, 106);
        _cmbMeals.SelectedIndexChanged += CmbMeals_Changed;
        Controls.Add(_cmbMeals);

        _lblCal.Font     = new Font("Segoe UI", 13, FontStyle.Bold);
        _lblCal.Location = new Point(20, 148);
        Controls.Add(_lblCal);

        var btnAdd = new Button
        {
            Text      = "Add to Today's Log",
            Font      = new Font("Segoe UI", 13, FontStyle.Bold),
            BackColor = Color.FromArgb(39, 174, 96),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(20, 182),
            Width     = 400,
            Height    = 46,
            Cursor    = Cursors.Hand
        };
        btnAdd.FlatAppearance.BorderSize = 0;
        btnAdd.Click += BtnAdd_Click;
        Controls.Add(btnAdd);

        Controls.Add(new Label { Text = "Meals logged today:", AutoSize = true, Location = new Point(20, 244) });
        _lstLogged.Location = new Point(20, 268);
        Controls.Add(_lstLogged);

        _lblStatus.Font     = new Font("Segoe UI", 10);
        _lblStatus.Location = new Point(20, 418);
        Controls.Add(_lblStatus);

        var btnBack = new Button
        {
            Text      = "← Back",
            Font      = new Font("Segoe UI", 11),
            BackColor = Color.White,
            ForeColor = Color.Gray,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(340, 418),
            Width     = 80,
            Height    = 30,
            Cursor    = Cursors.Hand
        };
        btnBack.FlatAppearance.BorderSize = 0;
        btnBack.Click += (s, e) => Close();
        Controls.Add(btnBack);

        Load += (s, e) => LoadMeals();
    }

    private void LoadMeals()
    {
        try
        {
            _meals = DatabaseHelper.GetAllMeals();
            _cmbMeals.Items.Clear();
            foreach (DataRow row in _meals.Rows)
                _cmbMeals.Items.Add($"{row["meal_name"]}  ({row["calories"]} kcal)");
            if (_cmbMeals.Items.Count > 0)
                _cmbMeals.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = "Could not load meals: " + ex.Message;
        }
    }

    private void CmbMeals_Changed(object? sender, EventArgs e)
    {
        if (_meals == null || _cmbMeals.SelectedIndex < 0) return;
        var cal = _meals.Rows[_cmbMeals.SelectedIndex]["calories"];
        _lblCal.Text = $"This meal has {cal} calories";
    }

    private void BtnAdd_Click(object? sender, EventArgs e)
    {
        if (_meals == null || _cmbMeals.SelectedIndex < 0) return;
        _lblStatus.Text = "";

        try
        {
            int logId  = DatabaseHelper.GetOrCreateDailyLog(Session.UserId, DateTime.Today);
            int mealId = (int)_meals.Rows[_cmbMeals.SelectedIndex]["meal_id"];
            DatabaseHelper.AddMealToLog(logId, mealId);

            string name = _meals.Rows[_cmbMeals.SelectedIndex]["meal_name"].ToString()!;
            _lstLogged.Items.Add($"✓  {name}");
            _lblStatus.ForeColor = Color.FromArgb(39, 174, 96);
            _lblStatus.Text      = "Meal added successfully!";
        }
        catch (Exception ex)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = ex.Message.Contains("already assigned")
                ? "This meal is already in today's log."
                : ex.Message;
        }
    }
}
