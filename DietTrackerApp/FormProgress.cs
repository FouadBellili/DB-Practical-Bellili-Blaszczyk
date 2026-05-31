using System.Drawing;
using System.Windows.Forms;

namespace DietTracker;

public class FormProgress : Form
{
    private readonly TextBox         _txtWeight = new() { Width = 200 };
    private readonly TextBox         _txtNotes  = new() { Width = 400 };
    private readonly DataGridView    _grid      = new() { Width = 400, Height = 190, ReadOnly = true };
    private readonly Label           _lblStatus = new() { AutoSize = true };

    public FormProgress()
    {
        Text            = "Diet Tracker — My Weight";
        ClientSize      = new Size(440, 490);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox     = false;
        BackColor       = Color.White;
        Font            = new Font("Segoe UI", 12);

        Controls.Add(new Label
        {
            Text      = "Record My Weight",
            Font      = new Font("Segoe UI", 20, FontStyle.Bold),
            ForeColor = Color.FromArgb(39, 174, 96),
            AutoSize  = true,
            Location  = new Point(20, 22)
        });

        Controls.Add(new Label { Text = "Today's weight (kg):", AutoSize = true, Location = new Point(20, 82) });
        _txtWeight.Location = new Point(20, 108);
        _txtWeight.Height   = 34;
        Controls.Add(_txtWeight);

        Controls.Add(new Label { Text = "Notes (optional):", AutoSize = true, Location = new Point(20, 152) });
        _txtNotes.Location  = new Point(20, 178);
        _txtNotes.Height    = 34;
        Controls.Add(_txtNotes);

        var btnSave = new Button
        {
            Text      = "Save Weight",
            Font      = new Font("Segoe UI", 13, FontStyle.Bold),
            BackColor = Color.FromArgb(39, 174, 96),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(20, 224),
            Width     = 400,
            Height    = 46,
            Cursor    = Cursors.Hand
        };
        btnSave.FlatAppearance.BorderSize = 0;
        btnSave.Click += BtnSave_Click;
        Controls.Add(btnSave);

        Controls.Add(new Label { Text = "My weight history:", AutoSize = true, Location = new Point(20, 284) });

        _grid.Location              = new Point(20, 308);
        _grid.AllowUserToAddRows    = false;
        _grid.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
        _grid.AutoSizeColumnsMode   = DataGridViewAutoSizeColumnsMode.Fill;
        _grid.BorderStyle           = BorderStyle.FixedSingle;
        _grid.BackgroundColor       = Color.White;
        Controls.Add(_grid);

        _lblStatus.Font     = new Font("Segoe UI", 10);
        _lblStatus.Location = new Point(20, 460);
        Controls.Add(_lblStatus);

        var btnBack = new Button
        {
            Text      = "← Back",
            Font      = new Font("Segoe UI", 11),
            BackColor = Color.White,
            ForeColor = Color.Gray,
            FlatStyle = FlatStyle.Flat,
            Location  = new Point(340, 458),
            Width     = 80,
            Height    = 30,
            Cursor    = Cursors.Hand
        };
        btnBack.FlatAppearance.BorderSize = 0;
        btnBack.Click += (s, e) => Close();
        Controls.Add(btnBack);

        Load += (s, e) => LoadHistory();
    }

    private void LoadHistory()
    {
        try
        {
            var table = DatabaseHelper.GetUserProgressHistory(Session.UserId);
            _grid.DataSource = table;
            if (_grid.Columns.Contains("date"))   _grid.Columns["date"]!.HeaderText   = "Date";
            if (_grid.Columns.Contains("weight")) _grid.Columns["weight"]!.HeaderText = "Weight (kg)";
            if (_grid.Columns.Contains("notes"))  _grid.Columns["notes"]!.HeaderText  = "Notes";
        }
        catch (Exception ex)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = "Could not load history: " + ex.Message;
        }
    }

    private void BtnSave_Click(object? sender, EventArgs e)
    {
        _lblStatus.Text = "";

        if (!double.TryParse(_txtWeight.Text.Trim(), out double w) || w <= 0)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = "Please enter a valid weight (e.g. 72.5).";
            return;
        }

        try
        {
            DatabaseHelper.RecordProgress(Session.UserId, DateTime.Today, w,
                string.IsNullOrWhiteSpace(_txtNotes.Text) ? null : _txtNotes.Text.Trim());

            _txtWeight.Clear();
            _txtNotes.Clear();
            _lblStatus.ForeColor = Color.FromArgb(39, 174, 96);
            _lblStatus.Text      = "Weight saved!";
            LoadHistory();
        }
        catch (Exception ex)
        {
            _lblStatus.ForeColor = Color.FromArgb(192, 57, 43);
            _lblStatus.Text      = ex.Message.Contains("50007")
                ? "You already recorded your weight today."
                : ex.Message;
        }
    }
}
