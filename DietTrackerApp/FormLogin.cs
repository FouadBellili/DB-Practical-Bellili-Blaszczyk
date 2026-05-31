using System.Drawing;
using System.Windows.Forms;

namespace DietTracker;

public class FormLogin : Form
{
    private readonly TextBox _txtEmail    = new() { Width = 360 };
    private readonly TextBox _txtPassword = new() { Width = 360, PasswordChar = '●' };
    private readonly Label   _lblError    = new() { ForeColor = Color.FromArgb(192, 57, 43), AutoSize = true };

    public FormLogin()
    {
        Text            = "Diet Tracker — Sign In";
        ClientSize      = new Size(440, 390);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox     = false;
        BackColor       = Color.White;
        Font            = new Font("Segoe UI", 12);

        Controls.Add(new Label
        {
            Text      = "Diet Tracker",
            Font      = new Font("Segoe UI", 26, FontStyle.Bold),
            ForeColor = Color.FromArgb(39, 174, 96),
            AutoSize  = true,
            Location  = new Point(100, 28)
        });

        Controls.Add(new Label
        {
            Text      = "Sign in to your account",
            ForeColor = Color.Gray,
            AutoSize  = true,
            Location  = new Point(126, 78)
        });

        AddLabeledField("Your email address", _txtEmail,    118);
        AddLabeledField("Your password",      _txtPassword, 183);

        _lblError.Location = new Point(40, 250);
        Controls.Add(_lblError);

        var btnLogin = MakeButton("Sign In", true, 278);
        btnLogin.Click += BtnLogin_Click;

        var btnRegister = MakeButton("Create an account", false, 335);
        btnRegister.Click += (s, e) =>
        {
            var reg = new FormRegister();
            if (reg.ShowDialog(this) == DialogResult.OK)
                _txtEmail.Text = reg.RegisteredEmail;
        };
    }

    private void AddLabeledField(string labelText, TextBox box, int y)
    {
        Controls.Add(new Label { Text = labelText, AutoSize = true, Location = new Point(40, y) });
        box.Location = new Point(40, y + 26);
        box.Height   = 32;
        Controls.Add(box);
    }

    private Button MakeButton(string text, bool primary, int y)
    {
        var btn = new Button
        {
            Text      = text,
            Font      = new Font("Segoe UI", 13, FontStyle.Bold),
            BackColor = primary ? Color.FromArgb(39, 174, 96) : Color.White,
            ForeColor = primary ? Color.White : Color.FromArgb(39, 174, 96),
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(40, y),
            Width     = 360,
            Height    = 44,
            Cursor    = Cursors.Hand
        };
        btn.FlatAppearance.BorderSize  = primary ? 0 : 1;
        btn.FlatAppearance.BorderColor = Color.FromArgb(39, 174, 96);
        Controls.Add(btn);
        return btn;
    }

    private void BtnLogin_Click(object? sender, EventArgs e)
    {
        _lblError.Text = "";

        if (string.IsNullOrWhiteSpace(_txtEmail.Text) || string.IsNullOrWhiteSpace(_txtPassword.Text))
        {
            _lblError.Text = "Please fill in all fields.";
            return;
        }

        try
        {
            var row = DatabaseHelper.LoginUser(_txtEmail.Text.Trim(), _txtPassword.Text);
            if (row == null)
            {
                _lblError.Text = "Incorrect email or password. Please try again.";
                return;
            }

            Session.UserId   = (int)row["user_id"];
            Session.UserName = row["user_name"].ToString()!;

            var dash = new FormDashboard();
            dash.FormClosed += (s, e) => Close();
            dash.Show();
            Hide();
        }
        catch (Exception ex)
        {
            _lblError.Text = "Connection error: " + ex.Message;
        }
    }
}
