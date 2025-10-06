using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;

namespace PartAttributes
{
    public partial class PartAttributeType2Entry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Any initialization code can go here
                lblStatus.Text = "";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate required fields
                if (!ValidateForm())
                {
                    return;
                }

                // Get connection string
                string connectionString = ConfigurationManager.ConnectionStrings["PartsDatabase"].ConnectionString;

                // SQL Insert statement - Phase Config fields set to "-", new fields included
                string sql = @"INSERT INTO tblPartAttribute 
                    (attrPartNumber, attrStandard, attrIRrating, attrRatedCurrent, attrRMSSym, 
                     attrSystemVolts, attrFrequency, attrGround, attrPhaseConfig1, attrPhaseConfig2, 
                     attrPhaseConfig3, attrPhaseConfig4, attrPhaseConfig5, attrSystemConfig, attrNeutral,
                     attrBreaker1, attrBreaker1Outlet, attrBreaker1Amps, attrBreaker2, attrBreaker2Outlet, 
                     attrBreaker2Amps, attrBreaker3, attrBreaker3Outlet, attrBreaker3Amps, attrBreaker4, 
                     attrBreaker4Outlet, attrBreaker4Amps, attrBreaker5, attrBreaker5Outlet, attrBreaker5Amps, 
                     attrSerialNumber) 
                VALUES 
                    (@PartNumber, @Standard, @IRRating, @RatedCurrent, @RMSSym, 
                     @SystemVolts, @Frequency, @Ground, '-', '-', '-', '-', '-', @SystemConfig, @Neutral,
                     @Breaker1, @Breaker1Outlet, @Breaker1Amps, @Breaker2, @Breaker2Outlet, 
                     @Breaker2Amps, @Breaker3, @Breaker3Outlet, @Breaker3Amps, @Breaker4, 
                     @Breaker4Outlet, @Breaker4Amps, @Breaker5, @Breaker5Outlet, @Breaker5Amps, 
                     @SerialNumber)";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        // Add parameters to prevent SQL injection
                        AddParameters(command);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Part attribute saved successfully!", Color.Green);
                            ClearForm();
                        }
                        else
                        {
                            ShowMessage("Error: No rows were inserted.", Color.Red);
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                // Handle specific SQL errors
                if (sqlEx.Number == 2627) // Primary key violation
                {
                    ShowMessage("Error: A part with this Part Number already exists.", Color.Red);
                }
                else
                {
                    ShowMessage("Database Error: " + sqlEx.Message, Color.Red);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, Color.Red);
            }
        }

        private void AddParameters(SqlCommand command)
        {
            // Basic Information
            command.Parameters.AddWithValue("@PartNumber", txtPartNumber.Text.Trim());
            command.Parameters.AddWithValue("@Standard", txtStandard.Text.Trim());
            command.Parameters.AddWithValue("@SerialNumber", 1); // Always 1

            // Electrical Ratings
            command.Parameters.AddWithValue("@IRRating", txtIRRating.Text.Trim());
            command.Parameters.AddWithValue("@RatedCurrent", txtRatedCurrent.Text.Trim());
            command.Parameters.AddWithValue("@RMSSym", txtRMSSym.Text.Trim());
            command.Parameters.AddWithValue("@SystemVolts", txtSystemVolts.Text.Trim());
            command.Parameters.AddWithValue("@Frequency", txtFrequency.Text.Trim());
            command.Parameters.AddWithValue("@Ground", txtGround.Text.Trim());

            // System Configuration (NEW) - use "-" if blank
            command.Parameters.AddWithValue("@SystemConfig", string.IsNullOrWhiteSpace(txtSystemConfig.Text) ? "-" : txtSystemConfig.Text.Trim());
            command.Parameters.AddWithValue("@Neutral", string.IsNullOrWhiteSpace(txtNeutral.Text) ? "-" : txtNeutral.Text.Trim());

            // Phase Configuration fields are hardcoded to "-" in the SQL statement above

            // Breaker Information - use "-" if blank
            command.Parameters.AddWithValue("@Breaker1", string.IsNullOrWhiteSpace(txtBreaker1.Text) ? "-" : txtBreaker1.Text.Trim());
            command.Parameters.AddWithValue("@Breaker1Outlet", string.IsNullOrWhiteSpace(txtBreaker1Outlet.Text) ? "-" : txtBreaker1Outlet.Text.Trim());
            command.Parameters.AddWithValue("@Breaker1Amps", string.IsNullOrWhiteSpace(txtBreaker1Amps.Text) ? "-" : txtBreaker1Amps.Text.Trim());

            command.Parameters.AddWithValue("@Breaker2", string.IsNullOrWhiteSpace(txtBreaker2.Text) ? "-" : txtBreaker2.Text.Trim());
            command.Parameters.AddWithValue("@Breaker2Outlet", string.IsNullOrWhiteSpace(txtBreaker2Outlet.Text) ? "-" : txtBreaker2Outlet.Text.Trim());
            command.Parameters.AddWithValue("@Breaker2Amps", string.IsNullOrWhiteSpace(txtBreaker2Amps.Text) ? "-" : txtBreaker2Amps.Text.Trim());

            command.Parameters.AddWithValue("@Breaker3", string.IsNullOrWhiteSpace(txtBreaker3.Text) ? "-" : txtBreaker3.Text.Trim());
            command.Parameters.AddWithValue("@Breaker3Outlet", string.IsNullOrWhiteSpace(txtBreaker3Outlet.Text) ? "-" : txtBreaker3Outlet.Text.Trim());
            command.Parameters.AddWithValue("@Breaker3Amps", string.IsNullOrWhiteSpace(txtBreaker3Amps.Text) ? "-" : txtBreaker3Amps.Text.Trim());

            command.Parameters.AddWithValue("@Breaker4", string.IsNullOrWhiteSpace(txtBreaker4.Text) ? "-" : txtBreaker4.Text.Trim());
            command.Parameters.AddWithValue("@Breaker4Outlet", string.IsNullOrWhiteSpace(txtBreaker4Outlet.Text) ? "-" : txtBreaker4Outlet.Text.Trim());
            command.Parameters.AddWithValue("@Breaker4Amps", string.IsNullOrWhiteSpace(txtBreaker4Amps.Text) ? "-" : txtBreaker4Amps.Text.Trim());

            command.Parameters.AddWithValue("@Breaker5", string.IsNullOrWhiteSpace(txtBreaker5.Text) ? "-" : txtBreaker5.Text.Trim());
            command.Parameters.AddWithValue("@Breaker5Outlet", string.IsNullOrWhiteSpace(txtBreaker5Outlet.Text) ? "-" : txtBreaker5Outlet.Text.Trim());
            command.Parameters.AddWithValue("@Breaker5Amps", string.IsNullOrWhiteSpace(txtBreaker5Amps.Text) ? "-" : txtBreaker5Amps.Text.Trim());
        }

        private bool ValidateForm()
        {
            // Check required fields
            if (string.IsNullOrWhiteSpace(txtPartNumber.Text))
            {
                ShowMessage("Part Number is required.", Color.Red);
                txtPartNumber.Focus();
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtStandard.Text))
            {
                ShowMessage("Standard is required.", Color.Red);
                txtStandard.Focus();
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtIRRating.Text))
            {
                ShowMessage("IR Rating is required.", Color.Red);
                txtIRRating.Focus();
                return false;
            }

            return true;
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowMessage("Form cleared.", Color.Blue);
        }

        private void ClearForm()
        {
            // Clear all text boxes
            txtPartNumber.Text = "";
            txtStandard.Text = "";
            txtIRRating.Text = "";
            txtRatedCurrent.Text = "";
            txtRMSSym.Text = "";
            txtSystemVolts.Text = "";
            txtFrequency.Text = "";
            txtGround.Text = "";

            txtSystemConfig.Text = "";
            txtNeutral.Text = "";

            txtBreaker1.Text = "";
            txtBreaker1Outlet.Text = "";
            txtBreaker1Amps.Text = "";

            txtBreaker2.Text = "";
            txtBreaker2Outlet.Text = "";
            txtBreaker2Amps.Text = "";

            txtBreaker3.Text = "";
            txtBreaker3Outlet.Text = "";
            txtBreaker3Amps.Text = "";

            txtBreaker4.Text = "";
            txtBreaker4Outlet.Text = "";
            txtBreaker4Amps.Text = "";

            txtBreaker5.Text = "";
            txtBreaker5Outlet.Text = "";
            txtBreaker5Amps.Text = "";

            // Clear status message
            lblStatus.Text = "";
        }

        private void ShowMessage(string message, Color color)
        {
            lblStatus.Text = message;
            lblStatus.ForeColor = color;
            lblStatus.Visible = true;
        }
    }
}