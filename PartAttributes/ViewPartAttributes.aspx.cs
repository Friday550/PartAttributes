using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI.WebControls;

namespace PartAttributes
{
    public partial class ViewPartAttributes : System.Web.UI.Page
    {
        private const string DELETE_PASSWORD = "admin123"; // Move to Web.config when ready

        // ─────────────────────────────────────────────
        // Page load
        // ─────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllPartAttributes();
            }
        }

        // ─────────────────────────────────────────────
        // Data loading
        // ─────────────────────────────────────────────
        private void LoadAllPartAttributes()
        {
            try
            {
                string sql = "SELECT * FROM tblPartAttribute ORDER BY attrPartNumber";
                DataTable dt = FetchData(sql, null);
                BindGrid(dt);
                lblStatus.Text = "";
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading data: " + ex.Message, Color.Red);
            }
        }

        // ─────────────────────────────────────────────
        // Search / Show All
        // ─────────────────────────────────────────────
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            if (string.IsNullOrWhiteSpace(searchTerm))
            {
                ShowMessage("Please enter a search term.", Color.Orange);
                return;
            }

            try
            {
                string sql = @"SELECT * FROM tblPartAttribute
                               WHERE attrPartNumber LIKE @SearchTerm
                                  OR attrStandard   LIKE @SearchTerm
                               ORDER BY attrPartNumber";

                DataTable dt = FetchData(sql, cmd =>
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%"));

                BindGrid(dt);

                ShowMessage(
                    dt.Rows.Count == 0
                        ? $"No records found matching '{searchTerm}'"
                        : $"Found {dt.Rows.Count} record(s) matching '{searchTerm}'",
                    dt.Rows.Count == 0 ? Color.Orange : Color.Green);
            }
            catch (Exception ex)
            {
                ShowMessage("Error searching data: " + ex.Message, Color.Red);
            }
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadAllPartAttributes();
            ShowMessage("Displaying all records.", Color.Green);
        }

        // ─────────────────────────────────────────────
        // Paging
        // ─────────────────────────────────────────────
        protected void gvPartAttributes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPartAttributes.PageIndex = e.NewPageIndex;

            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                btnSearch_Click(sender, e);
            else
                LoadAllPartAttributes();
        }

        // Required by GridView OnRowDeleting — actual delete is in btnConfirmDelete_Click
        protected void gvPartAttributes_RowDeleting(object sender, GridViewDeleteEventArgs e) { }

        // ─────────────────────────────────────────────
        // DELETE
        // ─────────────────────────────────────────────
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDeletePassword.Text))
            {
                ShowMessage("Please enter a password.", Color.Red);
                return;
            }

            if (txtDeletePassword.Text != DELETE_PASSWORD)
            {
                ShowMessage("Incorrect password. Delete operation cancelled.", Color.Red);
                txtDeletePassword.Text = "";
                return;
            }

            // Use the original part number stored by JS in the hidden field
            string partNumber = hdnOrigPartNumber.Value;

            if (string.IsNullOrWhiteSpace(partNumber))
            {
                ShowMessage("Error: Could not identify the part to delete.", Color.Red);
                return;
            }

            try
            {
                int rows = RunNonQuery(
                    "DELETE FROM tblPartAttribute WHERE attrPartNumber = @PartNumber",
                    cmd => cmd.Parameters.AddWithValue("@PartNumber", partNumber));

                if (rows > 0)
                {
                    ShowMessage($"Part '{partNumber}' deleted successfully.", Color.Green);
                    ReloadGrid();
                }
                else
                {
                    ShowMessage("Error: Part not found or already deleted.", Color.Red);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting record: " + ex.Message, Color.Red);
            }
            finally
            {
                txtDeletePassword.Text = "";
            }
        }

        // ─────────────────────────────────────────────
        // EDIT — Save Changes
        // ─────────────────────────────────────────────
        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            string originalPartNumber = hdnOrigPartNumber.Value;

            if (string.IsNullOrWhiteSpace(originalPartNumber))
            {
                ShowMessage("Error: Could not identify the part to update.", Color.Red);
                return;
            }

            if (string.IsNullOrWhiteSpace(editPartNumber.Text))
            {
                ShowMessage("Part Number cannot be blank.", Color.Red);
                return;
            }

            try
            {
                const string sql = @"
                    UPDATE tblPartAttribute SET
                        attrPartNumber   = @NewPartNumber,
                        attrStandard     = @Standard,
                        attrIRrating     = @IRRating,
                        attrRatedCurrent = @RatedCurrent,
                        attrRMSSym       = @RMSSym,
                        attrSystemVolts  = @SystemVolts,
                        attrFrequency    = @Frequency,
                        attrGround       = @Ground,
                        attrNeutral      = @Neutral,
                        attrSystemConfig = @SystemConfig,
                        attrPhaseConfig1 = @PhaseConfig1,
                        attrPhaseConfig2 = @PhaseConfig2,
                        attrPhaseConfig3 = @PhaseConfig3,
                        attrPhaseConfig4 = @PhaseConfig4,
                        attrPhaseConfig5 = @PhaseConfig5,
                        attrBreaker1       = @Breaker1,
                        attrBreaker1Outlet = @Breaker1Outlet,
                        attrBreaker1Amps   = @Breaker1Amps,
                        attrBreaker2       = @Breaker2,
                        attrBreaker2Outlet = @Breaker2Outlet,
                        attrBreaker2Amps   = @Breaker2Amps,
                        attrBreaker3       = @Breaker3,
                        attrBreaker3Outlet = @Breaker3Outlet,
                        attrBreaker3Amps   = @Breaker3Amps,
                        attrBreaker4       = @Breaker4,
                        attrBreaker4Outlet = @Breaker4Outlet,
                        attrBreaker4Amps   = @Breaker4Amps,
                        attrBreaker5       = @Breaker5,
                        attrBreaker5Outlet = @Breaker5Outlet,
                        attrBreaker5Amps   = @Breaker5Amps
                    WHERE attrPartNumber = @OrigPartNumber";

                int rows = RunNonQuery(sql, cmd =>
                {
                    // WHERE clause — always the original key
                    cmd.Parameters.AddWithValue("@OrigPartNumber", originalPartNumber);

                    // New values (Part Number may have changed)
                    cmd.Parameters.AddWithValue("@NewPartNumber", editPartNumber.Text.Trim());
                    cmd.Parameters.AddWithValue("@Standard", editStandard.Text.Trim());
                    cmd.Parameters.AddWithValue("@IRRating", editIRRating.Text.Trim());
                    cmd.Parameters.AddWithValue("@RatedCurrent", editRatedCurrent.Text.Trim());
                    cmd.Parameters.AddWithValue("@RMSSym", editRMSSym.Text.Trim());
                    cmd.Parameters.AddWithValue("@SystemVolts", editSystemVolts.Text.Trim());
                    cmd.Parameters.AddWithValue("@Frequency", editFrequency.Text.Trim());
                    cmd.Parameters.AddWithValue("@Ground", editGround.Text.Trim());
                    cmd.Parameters.AddWithValue("@Neutral", DashIfBlank(editNeutral.Text));
                    cmd.Parameters.AddWithValue("@SystemConfig", DashIfBlank(editSystemConfig.Text));
                    cmd.Parameters.AddWithValue("@PhaseConfig1", DashIfBlank(editPhaseConfig1.Text));
                    cmd.Parameters.AddWithValue("@PhaseConfig2", DashIfBlank(editPhaseConfig2.Text));
                    cmd.Parameters.AddWithValue("@PhaseConfig3", DashIfBlank(editPhaseConfig3.Text));
                    cmd.Parameters.AddWithValue("@PhaseConfig4", DashIfBlank(editPhaseConfig4.Text));
                    cmd.Parameters.AddWithValue("@PhaseConfig5", DashIfBlank(editPhaseConfig5.Text));
                    cmd.Parameters.AddWithValue("@Breaker1", DashIfBlank(editBreaker1.Text));
                    cmd.Parameters.AddWithValue("@Breaker1Outlet", DashIfBlank(editBreaker1Outlet.Text));
                    cmd.Parameters.AddWithValue("@Breaker1Amps", DashIfBlank(editBreaker1Amps.Text));
                    cmd.Parameters.AddWithValue("@Breaker2", DashIfBlank(editBreaker2.Text));
                    cmd.Parameters.AddWithValue("@Breaker2Outlet", DashIfBlank(editBreaker2Outlet.Text));
                    cmd.Parameters.AddWithValue("@Breaker2Amps", DashIfBlank(editBreaker2Amps.Text));
                    cmd.Parameters.AddWithValue("@Breaker3", DashIfBlank(editBreaker3.Text));
                    cmd.Parameters.AddWithValue("@Breaker3Outlet", DashIfBlank(editBreaker3Outlet.Text));
                    cmd.Parameters.AddWithValue("@Breaker3Amps", DashIfBlank(editBreaker3Amps.Text));
                    cmd.Parameters.AddWithValue("@Breaker4", DashIfBlank(editBreaker4.Text));
                    cmd.Parameters.AddWithValue("@Breaker4Outlet", DashIfBlank(editBreaker4Outlet.Text));
                    cmd.Parameters.AddWithValue("@Breaker4Amps", DashIfBlank(editBreaker4Amps.Text));
                    cmd.Parameters.AddWithValue("@Breaker5", DashIfBlank(editBreaker5.Text));
                    cmd.Parameters.AddWithValue("@Breaker5Outlet", DashIfBlank(editBreaker5Outlet.Text));
                    cmd.Parameters.AddWithValue("@Breaker5Amps", DashIfBlank(editBreaker5Amps.Text));
                });

                if (rows > 0)
                {
                    ShowMessage($"Part '{editPartNumber.Text.Trim()}' updated successfully.", Color.Green);
                    ReloadGrid();
                }
                else
                {
                    ShowMessage("Error: No rows were updated. The part may no longer exist.", Color.Red);
                }
            }
            catch (SqlException sqlEx)
            {
                // Catch duplicate key if the new Part Number already exists
                ShowMessage(sqlEx.Number == 2627
                    ? "Error: A part with that Part Number already exists."
                    : "Database error: " + sqlEx.Message, Color.Red);
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating record: " + ex.Message, Color.Red);
            }
        }

        // ─────────────────────────────────────────────
        // Helpers
        // ─────────────────────────────────────────────

        private void ReloadGrid()
        {
            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                btnSearch_Click(this, EventArgs.Empty);
            else
                LoadAllPartAttributes();
        }

        private void BindGrid(DataTable dt)
        {
            gvPartAttributes.DataSource = dt;
            gvPartAttributes.DataBind();
            UpdateRecordCount(dt.Rows.Count);
        }

        private void UpdateRecordCount(int count)
        {
            lblRecordCount.Text = count == 0 ? "No records found"
                                : count == 1 ? "Displaying 1 record"
                                             : $"Displaying {count} records";
        }

        private void ShowMessage(string message, Color color)
        {
            lblStatus.Text = message;
            lblStatus.ForeColor = color;
            lblStatus.Visible = true;
        }

        private static string DashIfBlank(string value)
            => string.IsNullOrWhiteSpace(value) ? "-" : value.Trim();

        private string GetConnectionString()
            => ConfigurationManager.ConnectionStrings["PartsDatabase"].ConnectionString;

        private DataTable FetchData(string sql, Action<SqlCommand> addParams)
        {
            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand(sql, conn))
            {
                addParams?.Invoke(cmd);
                conn.Open();
                var dt = new DataTable();
                var adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
                return dt;
            }
        }

        private int RunNonQuery(string sql, Action<SqlCommand> addParams)
        {
            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand(sql, conn))
            {
                addParams?.Invoke(cmd);
                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }
    }
}
