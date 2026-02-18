using System;
using System.Drawing;
using System.Web.UI.WebControls;

namespace PartAttributes
{
    public partial class PartAttributeType2Entry : PartAttributeBasePage
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
                     attrSerialNumber)
                VALUES 
                    (@PartNumber, @Standard, @IRRating, @RatedCurrent, @RMSSym,
                     @SystemVolts, @Frequency, @Ground,
                     '-', '-', '-', '-', '-',
                     @SystemConfig, @Neutral,
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

                cmd.Parameters.AddWithValue("@SystemConfig", DashIfBlank(txtSystemConfig.Text));
                cmd.Parameters.AddWithValue("@Neutral", DashIfBlank(txtNeutral.Text));
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
                && RequireField(txtRMSSym, "RMS Sym / Protection Device")
                && RequireField(txtSystemVolts, "System Volts")
                && RequireField(txtFrequency, "Frequency")
                && RequireField(txtGround, "Ground")
                && RequireField(txtSystemConfig, "System Config")
                && RequireField(txtNeutral, "Neutral");
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
            txtSystemConfig.Text = txtNeutral.Text = "";

            StatusLabel.Text = "";
        }
    }
}
