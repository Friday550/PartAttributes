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
        // Set your delete password here
        private const string DELETE_PASSWORD = "admin123"; // Change this to your desired password

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllPartAttributes();
            }
        }

        private void LoadAllPartAttributes()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["PartsDatabase"].ConnectionString;
                string sql = "SELECT * FROM tblPartAttribute ORDER BY attrPartNumber";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        connection.Open();
                        SqlDataAdapter adapter = new SqlDataAdapter(command);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        gvPartAttributes.DataSource = dt;
                        gvPartAttributes.DataBind();

                        // Update record count
                        UpdateRecordCount(dt.Rows.Count);
                    }
                }

                lblStatus.Text = "";
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading data: " + ex.Message, Color.Red);
            }
        }

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
                string connectionString = ConfigurationManager.ConnectionStrings["PartsDatabase"].ConnectionString;

                // Search in Part Number and Standard fields
                string sql = @"SELECT * FROM tblPartAttribute 
                              WHERE attrPartNumber LIKE @SearchTerm 
                              OR attrStandard LIKE @SearchTerm
                              ORDER BY attrPartNumber";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                        connection.Open();
                        SqlDataAdapter adapter = new SqlDataAdapter(command);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        gvPartAttributes.DataSource = dt;
                        gvPartAttributes.DataBind();

                        // Update record count
                        UpdateRecordCount(dt.Rows.Count);

                        if (dt.Rows.Count == 0)
                        {
                            ShowMessage("No records found matching '" + searchTerm + "'", Color.Orange);
                        }
                        else
                        {
                            ShowMessage("Found " + dt.Rows.Count + " record(s) matching '" + searchTerm + "'", Color.Green);
                        }
                    }
                }
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

        protected void gvPartAttributes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPartAttributes.PageIndex = e.NewPageIndex;

            // Reload data based on whether we're searching or showing all
            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
            {
                btnSearch_Click(sender, e);
            }
            else
            {
                LoadAllPartAttributes();
            }
        }

        protected void gvPartAttributes_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // This event is triggered by the Delete command, but we handle it in btnConfirmDelete_Click
            // We need this event handler declared for the GridView's OnRowDeleting to work
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            // Validate password
            string enteredPassword = txtDeletePassword.Text;

            if (string.IsNullOrWhiteSpace(enteredPassword))
            {
                ShowMessage("Please enter a password.", Color.Red);
                return;
            }

            if (enteredPassword != DELETE_PASSWORD)
            {
                ShowMessage("Incorrect password. Delete operation cancelled.", Color.Red);
                txtDeletePassword.Text = ""; // Clear the password field
                return;
            }

            // Get the row index
            int rowIndex = Convert.ToInt32(hdnRowIndex.Value);

            if (rowIndex < 0 || rowIndex >= gvPartAttributes.Rows.Count)
            {
                ShowMessage("Error: Invalid row index.", Color.Red);
                return;
            }

            // Get the Part Number from the GridView
            string partNumber = gvPartAttributes.Rows[rowIndex].Cells[1].Text;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["PartsDatabase"].ConnectionString;
                string sql = "DELETE FROM tblPartAttribute WHERE attrPartNumber = @PartNumber";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        command.Parameters.AddWithValue("@PartNumber", partNumber);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Part '" + partNumber + "' deleted successfully.", Color.Green);

                            // Reload the grid
                            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                            {
                                btnSearch_Click(sender, e);
                            }
                            else
                            {
                                LoadAllPartAttributes();
                            }
                        }
                        else
                        {
                            ShowMessage("Error: Part not found or already deleted.", Color.Red);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting record: " + ex.Message, Color.Red);
            }
            finally
            {
                // Clear password field
                txtDeletePassword.Text = "";
            }
        }

        private void UpdateRecordCount(int count)
        {
            if (count == 0)
            {
                lblRecordCount.Text = "No records found";
            }
            else if (count == 1)
            {
                lblRecordCount.Text = "Displaying 1 record";
            }
            else
            {
                lblRecordCount.Text = "Displaying " + count + " records";
            }
        }

        private void ShowMessage(string message, Color color)
        {
            lblStatus.Text = message;
            lblStatus.ForeColor = color;
            lblStatus.Visible = true;
        }
    }
}