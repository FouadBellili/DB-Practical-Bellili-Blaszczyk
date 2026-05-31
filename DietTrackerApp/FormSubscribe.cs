using System.Data;
using System.Drawing;
using System.Windows.Forms;

namespace DietTracker;

public class FormSubscribe : Form
{
    private readonly ComboBox  _cmbPlans  = new() { Width = 400, DropDownStyle = ComboBoxStyle.DropDownList };
    private readonly Label     _lblDetail = new() { AutoSize = false, Width = 400, Height = 52, ForeColor = Color.Gray };
    private readonly ComboBox  _cmbMethod = new() { Width = 400, DropDownStyle = ComboBoxStyle.DropDownList };
    private readonly Label     _lblStatus = new() { AutoSize = true };

    private DataTable? _plans;

    public FormSubscribe()
    {
        Text            = "Diet Tracker — Subscribe";
        ClientSize      = new Size(440, 370);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox     = false;
        BackColor       = Color.White;
        Font            = new Font("Segoe UI", 12);

        Controls.Add(new Label
        {
            Text      = "Choose a Subscription",
            Font      = new Font("Segoe UI", 20, FontStyle.Bold),
            ForeColor = Color.FromArgb(39, 174, 96),
            AutoSize  = true,
            Location  = new Point(20, 22)
        });

        Controls.Add(new Label { Text = "Plan:", AutoSize = true, Location = new Point(20, 80) });
        _cmbPlans.Location = new Point(20, 106);
        _cmbPlans.SelectedIndexChanged += CmbPlans_Changed;
        Controls.Add(_cmbPlans);

        _lblDetail.Font     = new Font("Segoe UI", 10);
        _lblDetail.Location = new Point(20, 148);
        Controls.Add(_lblDetail);

        Controls.Add(new Label { Text = "Payment method:", AutoSize = true, Location = new Point(20, 208) });
        _cmbMethod.Items.AddRange(new[] { "Credit Card", "PayPal", "MB Way", "Bank Transfer" });
        _cmbMethod.SelectedIndex = 0;
        _cmbMethod.Location      = new Point(20, 234);
        Controls.Add(_cmbMethod);

        var btnSubscribe = new Button
        {
            Text      = "Subscribe Now",
            Font      = new Font("Segoe UI", 13, FontStyle.Bold),
            BackColor = Color.FromArgb(39, 174, 96),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(20, 282),
            Width     = 400,
            Height    = 46,
            Cursor    = Cursors.Hand
        };
        btnSubscribe.FlatAppearance.BorderSize = 0;
        btnSubscribe.Click += BtnSubscribe_Click;
        Controls.Add(btnSubscribe);

        _lblStatus.Font     = new Font("Segoe UI", 10);
        _lblStatus.Location = new Point(20, 338);
        Controls.Add(_lblStatus);

        Load += (s, e) => LoadPlans();
    }

    private void LoadPlans()
    {
        try
        {
            _plans = DatabaseHelper.GetAllSubscriptionPlans();
            _cmbPlans.Items.Clear();
            foreach (DataRow row in _plans.Rows)
                _cmbPlans.Items.Add($"{row["subscription_name"]}  —  €{row["price"]} / {row["duration_days"]} days");
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
        _lblDetail.Text = _plans.Rows[_cmbPlans.SelectedIndex]["features"].ToString();
    }

    private void BtnSubscribe_Click(object? sender, EventArgs e)
    {
        if (_plans == null || _cmbPlans.SelectedIndex < 0) return;
        _lblStatus.Text = "";

        try
        {
            int planId = (int)_plans.Rows[_cmbPlans.SelectedIndex]["subscription_plan_id"];
            DatabaseHelper.SubscribeUser(Session.UserId, planId, _cmbMethod.SelectedItem!.ToString()!);
            _lblStatus.ForeColor = Color.FromArgb(39, 174, 96);
            _lblStatus.Text      = "Subscribed successfully!";
        }
        catch (Exception ex)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = ex.Message;
        }
    }
}
