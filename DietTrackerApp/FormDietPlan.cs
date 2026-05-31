using System.Data;
using System.Drawing;
using System.Windows.Forms;

namespace DietTracker;

public class FormDietPlan : Form
{
    private readonly ComboBox       _cmbPlans     = new() { Width = 400, DropDownStyle = ComboBoxStyle.DropDownList };
    private readonly Label          _lblDesc      = new() { AutoSize = false, Width = 400, Height = 52, ForeColor = Color.Gray };
    private readonly DateTimePicker _dtpStart     = new() { Width = 190 };
    private readonly DateTimePicker _dtpEnd       = new() { Width = 190 };
    private readonly Label          _lblStatus    = new() { AutoSize = true };

    private DataTable? _plans;

    public FormDietPlan()
    {
        Text            = "Diet Tracker — My Diet Plan";
        ClientSize      = new Size(440, 440);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox     = false;
        BackColor       = Color.White;
        Font            = new Font("Segoe UI", 12);

        Controls.Add(new Label
        {
            Text      = "My Diet Plan",
            Font      = new Font("Segoe UI", 20, FontStyle.Bold),
            ForeColor = Color.FromArgb(39, 174, 96),
            AutoSize  = true,
            Location  = new Point(20, 22)
        });

        Controls.Add(new Label { Text = "Choose a plan:", AutoSize = true, Location = new Point(20, 82) });
        _cmbPlans.Location = new Point(20, 108);
        _cmbPlans.SelectedIndexChanged += CmbPlans_Changed;
        Controls.Add(_cmbPlans);

        _lblDesc.Font     = new Font("Segoe UI", 10);
        _lblDesc.Location = new Point(20, 150);
        Controls.Add(_lblDesc);

        Controls.Add(new Label { Text = "Start date:", AutoSize = true, Location = new Point(20, 212) });
        _dtpStart.Location = new Point(20, 238);
        _dtpStart.Value    = DateTime.Today;
        Controls.Add(_dtpStart);

        Controls.Add(new Label { Text = "End date:", AutoSize = true, Location = new Point(230, 212) });
        _dtpEnd.Location = new Point(230, 238);
        _dtpEnd.Value    = DateTime.Today.AddDays(29);
        Controls.Add(_dtpEnd);

        var btnStart = new Button
        {
            Text      = "Start this plan",
            Font      = new Font("Segoe UI", 13, FontStyle.Bold),
            BackColor = Color.FromArgb(39, 174, 96),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(20, 288),
            Width     = 400,
            Height    = 46,
            Cursor    = Cursors.Hand
        };
        btnStart.FlatAppearance.BorderSize = 0;
        btnStart.Click += BtnStart_Click;
        Controls.Add(btnStart);

        _lblStatus.Font     = new Font("Segoe UI", 10);
        _lblStatus.Location = new Point(20, 348);
        Controls.Add(_lblStatus);

        var lblSubTitle = new Label
        {
            Text      = "Subscribe to unlock more plans:",
            AutoSize  = true,
            ForeColor = Color.Gray,
            Font      = new Font("Segoe UI", 10),
            Location  = new Point(20, 378)
        };
        Controls.Add(lblSubTitle);

        var btnSubscribe = new Button
        {
            Text      = "Subscribe",
            Font      = new Font("Segoe UI", 11),
            BackColor = Color.White,
            ForeColor = Color.FromArgb(39, 174, 96),
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(20, 400),
            Width     = 190,
            Height    = 34,
            Cursor    = Cursors.Hand
        };
        btnSubscribe.FlatAppearance.BorderColor = Color.FromArgb(39, 174, 96);
        btnSubscribe.FlatAppearance.BorderSize  = 1;
        btnSubscribe.Click += (s, e) => new FormSubscribe().ShowDialog(this);
        Controls.Add(btnSubscribe);

        var btnBack = new Button
        {
            Text      = "← Back",
            Font      = new Font("Segoe UI", 11),
            BackColor = Color.White,
            ForeColor = Color.Gray,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(340, 400),
            Width     = 80,
            Height    = 34,
            Cursor    = Cursors.Hand
        };
        btnBack.FlatAppearance.BorderSize = 0;
        btnBack.Click += (s, e) => Close();
        Controls.Add(btnBack);

        Load += (s, e) => LoadPlans();
    }

    private void LoadPlans()
    {
        try
        {
            _plans = DatabaseHelper.GetAllDietPlans();
            _cmbPlans.Items.Clear();
            foreach (DataRow row in _plans.Rows)
                _cmbPlans.Items.Add(row["plan_name"].ToString()!);
            if (_cmbPlans.Items.Count > 0)
                _cmbPlans.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = "Could not load plans: " + ex.Message;
        }
    }

    private void CmbPlans_Changed(object? sender, EventArgs e)
    {
        if (_plans == null || _cmbPlans.SelectedIndex < 0) return;
        _lblDesc.Text = _plans.Rows[_cmbPlans.SelectedIndex]["description"].ToString();
    }

    private void BtnStart_Click(object? sender, EventArgs e)
    {
        if (_plans == null || _cmbPlans.SelectedIndex < 0) return;
        _lblStatus.Text = "";

        if (_dtpEnd.Value.Date < _dtpStart.Value.Date)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = "The end date must be after the start date.";
            return;
        }

        try
        {
            int planId = (int)_plans.Rows[_cmbPlans.SelectedIndex]["diet_plan_id"];
            DatabaseHelper.AssignDietPlan(Session.UserId, planId, _dtpStart.Value, _dtpEnd.Value);
            _lblStatus.ForeColor = Color.FromArgb(39, 174, 96);
            _lblStatus.Text      = "Plan started successfully!";
        }
        catch (Exception ex)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = ex.Message.Contains("overlaps")
                ? "You already have this plan assigned for these dates."
                : ex.Message;
        }
    }
}
