using System;
using System.Drawing;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace PartAttributes
{
    public partial class PartAttributeEntry : PartAttributeBasePage
    {
        // ---------------------------------------------------------------
        // Wire up the abstract StatusLabel to this page's control
        // ---------------------------------------------------------------
        protected override Label StatusLabel => lblStatus;

        // ---------------------------------------------------------------
        // Save
        // ---------------------------------------------------------------
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!ValidateForm()) return;

            const string sql = @"
                INSERT INTO tblPartAttribute 
                    (attrPartNumber, attrStandard, attrIRrating, attrRatedCurrent, attrRMSSym, 
                     attrSystemVolts, attrFrequency, attrGround,
                     attrPhaseConfig1, attrPhaseConfig2, attrPhaseConfig3, attrPhaseConfig4, attrPhaseConfig5,
                     attrSystemConfig, attrNeutral,
                     attrBreaker1, attrBreaker1Outlet, attrBreaker1Amps,
                     attrBreaker2, attrBreaker2Outlet, attrBreaker2Amps,
                     attrBreaker3, attrBreaker3Outlet, attrBreaker3Amps,
                     attrBreaker4, attrBreaker4Outlet, attrBreaker4Amps,
                     attrBreaker5, attrBreaker5Outlet, attrBreaker5Amps,
                     attrSerialNumber) 
                VALUES 
                    (@PartNumber, @Standard, @IRRating, @RatedCurrent, @RMSSym,
                     @SystemVolts, @Frequency, @Ground,
                     @PhaseConfig1, @PhaseConfig2, @PhaseConfig3, @PhaseConfig4, @PhaseConfig5,
                     '-', '-',
                     @Breaker1, @Breaker1Outlet, @Breaker1Amps,
                     @Breaker2, @Breaker2Outlet, @Breaker2Amps,
                     @Breaker3, @Breaker3Outlet, @Breaker3Amps,
                     @Breaker4, @Breaker4Outlet, @Breaker4Amps,
                     @Breaker5, @Breaker5Outlet, @Breaker5Amps,
                     @SerialNumber)";

            int rows = ExecuteNonQuery(sql, cmd =>
            {
                cmd.Parameters.AddWithValue("@PartNumber", txtPartNumber.Text.Trim());
                cmd.Parameters.AddWithValue("@Standard", txtStandard.Text.Trim());
                cmd.Parameters.AddWithValue("@SerialNumber", 1);

                cmd.Parameters.AddWithValue("@IRRating", txtIRRating.Text.Trim());
                cmd.Parameters.AddWithValue("@RatedCurrent", txtRatedCurrent.Text.Trim());
                cmd.Parameters.AddWithValue("@RMSSym", txtRMSSym.Text.Trim());
                cmd.Parameters.AddWithValue("@SystemVolts", txtSystemVolts.Text.Trim());
                cmd.Parameters.AddWithValue("@Frequency", txtFrequency.Text.Trim());
                cmd.Parameters.AddWithValue("@Ground", txtGround.Text.Trim());

                cmd.Parameters.AddWithValue("@PhaseConfig1", DashIfBlank(txtPhaseConfig1.Text));
                cmd.Parameters.AddWithValue("@PhaseConfig2", DashIfBlank(txtPhaseConfig2.Text));
                cmd.Parameters.AddWithValue("@PhaseConfig3", DashIfBlank(txtPhaseConfig3.Text));
                cmd.Parameters.AddWithValue("@PhaseConfig4", DashIfBlank(txtPhaseConfig4.Text));
                cmd.Parameters.AddWithValue("@PhaseConfig5", DashIfBlank(txtPhaseConfig5.Text));

                cmd.Parameters.AddWithValue("@Breaker1", DashIfBlank(txtBreaker1.Text));
                cmd.Parameters.AddWithValue("@Breaker1Outlet", DashIfBlank(txtBreaker1Outlet.Text));
                cmd.Parameters.AddWithValue("@Breaker1Amps", DashIfBlank(txtBreaker1Amps.Text));

                cmd.Parameters.AddWithValue("@Breaker2", DashIfBlank(txtBreaker2.Text));
                cmd.Parameters.AddWithValue("@Breaker2Outlet", DashIfBlank(txtBreaker2Outlet.Text));
                cmd.Parameters.AddWithValue("@Breaker2Amps", DashIfBlank(txtBreaker2Amps.Text));

                cmd.Parameters.AddWithValue("@Breaker3", DashIfBlank(txtBreaker3.Text));
                cmd.Parameters.AddWithValue("@Breaker3Outlet", DashIfBlank(txtBreaker3Outlet.Text));
                cmd.Parameters.AddWithValue("@Breaker3Amps", DashIfBlank(txtBreaker3Amps.Text));

                cmd.Parameters.AddWithValue("@Breaker4", DashIfBlank(txtBreaker4.Text));
                cmd.Parameters.AddWithValue("@Breaker4Outlet", DashIfBlank(txtBreaker4Outlet.Text));
                cmd.Parameters.AddWithValue("@Breaker4Amps", DashIfBlank(txtBreaker4Amps.Text));

                cmd.Parameters.AddWithValue("@Breaker5", DashIfBlank(txtBreaker5.Text));
                cmd.Parameters.AddWithValue("@Breaker5Outlet", DashIfBlank(txtBreaker5Outlet.Text));
                cmd.Parameters.AddWithValue("@Breaker5Amps", DashIfBlank(txtBreaker5Amps.Text));
            });

            if (rows > 0)
            {
                ShowSuccess("Part attribute saved successfully!");
                ClearForm();
            }
        }

        // ---------------------------------------------------------------
        // Validation (page-specific fields)
        // ---------------------------------------------------------------
        protected override bool ValidateForm()
        {
            return ValidateCommonFields(txtPartNumber, txtStandard, txtIRRating)
                && RequireField(txtRatedCurrent, "Rated Current")
                && RequireField(txtRMSSym, "RMS Sym")
                && RequireField(txtSystemVolts, "System Volts")
                && RequireField(txtFrequency, "Frequency")
                && RequireField(txtGround, "Ground");
        }

        // ---------------------------------------------------------------
        // Clear
        // ---------------------------------------------------------------
        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowInfo("Form cleared.");
        }

        protected override void ClearForm()
        {
            txtPartNumber.Text = txtStandard.Text = txtIRRating.Text = "";
            txtRatedCurrent.Text = txtRMSSym.Text = txtSystemVolts.Text = "";
            txtFrequency.Text = txtGround.Text = "";

            txtPhaseConfig1.Text = txtPhaseConfig2.Text = txtPhaseConfig3.Text = "";
            txtPhaseConfig4.Text = txtPhaseConfig5.Text = "";

            txtBreaker1.Text = txtBreaker1Outlet.Text = txtBreaker1Amps.Text = "";
            txtBreaker2.Text = txtBreaker2Outlet.Text = txtBreaker2Amps.Text = "";
            txtBreaker3.Text = txtBreaker3Outlet.Text = txtBreaker3Amps.Text = "";
            txtBreaker4.Text = txtBreaker4Outlet.Text = txtBreaker4Amps.Text = "";
            txtBreaker5.Text = txtBreaker5Outlet.Text = txtBreaker5Amps.Text = "";

            StatusLabel.Text = "";
        }
    }
}
