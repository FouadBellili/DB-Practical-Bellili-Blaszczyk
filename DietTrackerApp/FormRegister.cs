using System.Drawing;
using System.Windows.Forms;

namespace DietTracker;

public class FormRegister : Form
{
    public string RegisteredEmail { get; private set; } = "";

    private readonly TextBox   _txtName     = new() { Width = 360 };
    private readonly TextBox   _txtEmail    = new() { Width = 360 };
    private readonly TextBox   _txtPassword = new() { Width = 360, PasswordChar = '●' };
    private readonly TextBox   _txtAge      = new() { Width = 360 };
    private readonly ComboBox  _cmbGender   = new() { Width = 360, DropDownStyle = ComboBoxStyle.DropDownList };
    private readonly TextBox   _txtHeight   = new() { Width = 360 };
    private readonly TextBox   _txtWeight   = new() { Width = 360 };
    private readonly ComboBox  _cmbGoal     = new() { Width = 360, DropDownStyle = ComboBoxStyle.DropDownList };
    private readonly Label     _lblError    = new() { ForeColor = Color.FromArgb(192, 57, 43), AutoSize = true };

    public FormRegister()
    {
        Text            = "Diet Tracker — Create Account";
        ClientSize      = new Size(440, 650);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox     = false;
        BackColor       = Color.White;
        Font            = new Font("Segoe UI", 12);

        Controls.Add(new Label
        {
            Text      = "Create your account",
            Font      = new Font("Segoe UI", 20, FontStyle.Bold),
            ForeColor = Color.FromArgb(39, 174, 96),
            AutoSize  = true,
            Location  = new Point(60, 22)
        });

        _cmbGender.Items.AddRange(new[] { "Male", "Female", "Other", "Prefer not to say" });
        _cmbGender.SelectedIndex = 0;

        _cmbGoal.Items.AddRange(new[] { "Lose weight", "Gain muscle", "Maintain weight", "Improve health" });
        _cmbGoal.SelectedIndex = 0;

        int y = 75;
        AddLabeledControl("Username",        _txtName,     ref y);
        AddLabeledControl("Email address",   _txtEmail,    ref y);
        AddLabeledControl("Password",        _txtPassword, ref y);
        AddLabeledControl("Age",             _txtAge,      ref y);
        AddLabeledControl("Gender",          _cmbGender,   ref y);
        AddLabeledControl("Height (cm)",     _txtHeight,   ref y);
        AddLabeledControl("Weight (kg)",     _txtWeight,   ref y);
        AddLabeledControl("Your goal",       _cmbGoal,     ref y);

        _lblError.Location = new Point(40, y);
        Controls.Add(_lblError);

        var btnCreate = new Button
        {
            Text      = "Create Account",
            Font      = new Font("Segoe UI", 13, FontStyle.Bold),
            BackColor = Color.FromArgb(39, 174, 96),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(40, y + 28),
            Width     = 360,
            Height    = 44,
            Cursor    = Cursors.Hand
        };
        btnCreate.FlatAppearance.BorderSize = 0;
        btnCreate.Click += BtnCreate_Click;
        Controls.Add(btnCreate);

        var btnBack = new Button
        {
            Text      = "Back to Sign In",
            Font      = new Font("Segoe UI", 11),
            BackColor = Color.White,
            ForeColor = Color.Gray,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(40, y + 80),
            Width     = 360,
            Height    = 36,
            Cursor    = Cursors.Hand
        };
        btnBack.FlatAppearance.BorderSize = 0;
        btnBack.Click += (s, e) => { DialogResult = DialogResult.Cancel; Close(); };
        Controls.Add(btnBack);

        ClientSize = new Size(440, y + 124);
    }

    private void AddLabeledControl(string labelText, Control control, ref int y)
    {
        Controls.Add(new Label { Text = labelText, AutoSize = true, Location = new Point(40, y) });
        control.Location = new Point(40, y + 26);
        if (control is TextBox tb) tb.Height = 32;
        if (control is ComboBox cb) cb.Height = 32;
        Controls.Add(control);
        y += 72;
    }

    private void BtnCreate_Click(object? sender, EventArgs e)
    {
        _lblError.Text = "";

        if (!int.TryParse(_txtAge.Text.Trim(), out int age) || age <= 0)
        {
            _lblError.Text = "Please enter a valid age.";
            return;
        }
        if (!double.TryParse(_txtHeight.Text.Trim(), out double height) || height <= 0)
        {
            _lblError.Text = "Please enter a valid height in cm.";
            return;
        }
        if (!double.TryParse(_txtWeight.Text.Trim(), out double weight) || weight <= 0)
        {
            _lblError.Text = "Please enter a valid weight in kg.";
            return;
        }
        if (string.IsNullOrWhiteSpace(_txtName.Text) ||
            string.IsNullOrWhiteSpace(_txtEmail.Text) ||
            string.IsNullOrWhiteSpace(_txtPassword.Text))
        {
            _lblError.Text = "Please fill in all fields.";
            return;
        }

        try
        {
            DatabaseHelper.RegisterUser(
                _txtName.Text.Trim(),
                _txtEmail.Text.Trim(),
                _txtPassword.Text,
                age,
                _cmbGender.SelectedItem!.ToString()!,
                height,
                weight,
                _cmbGoal.SelectedItem!.ToString()!);

            RegisteredEmail = _txtEmail.Text.Trim();
            MessageBox.Show("Account created successfully!\nYou can now sign in.", "Welcome!", MessageBoxButtons.OK, MessageBoxIcon.Information);
            DialogResult = DialogResult.OK;
            Close();
        }
        catch (Exception ex)
        {
            _lblError.Text = ex.Message.Contains("50030") || ex.Message.Contains("50031")
                ? ex.Message.Split('\'')[1]
                : "Error: " + ex.Message;
        }
    }
}
