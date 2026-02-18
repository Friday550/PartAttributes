using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PartAttributes
{
    /// <summary>
    /// Shared base class for PartAttributeEntry and PartAttributeType2Entry pages.
    /// Contains common DB helpers, validation utilities, and message display logic.
    /// </summary>
    public abstract class PartAttributeBasePage : Page
    {
        // ---------------------------------------------------------------
        // Abstract members — each subclass must implement these
        // ---------------------------------------------------------------

        /// <summary>The status Label control on the page.</summary>
        protected abstract Label StatusLabel { get; }

        /// <summary>Validates the form inputs. Returns true if valid.</summary>
        protected abstract bool ValidateForm();

        /// <summary>Clears all form fields.</summary>
        protected abstract void ClearForm();

        // ---------------------------------------------------------------
        // Shared: Page lifecycle
        // ---------------------------------------------------------------

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            if (!IsPostBack)
            {
                StatusLabel.Text = "";
            }
        }

        // ---------------------------------------------------------------
        // Shared: UI helpers
        // ---------------------------------------------------------------

        /// <summary>Displays a coloured status message on the page.</summary>
        protected void ShowMessage(string message, Color color)
        {
            StatusLabel.Text = message;
            StatusLabel.ForeColor = color;
            StatusLabel.Visible = true;
        }

        protected void ShowSuccess(string message) => ShowMessage(message, Color.Green);
        protected void ShowError(string message) => ShowMessage(message, Color.Red);
        protected void ShowInfo(string message) => ShowMessage(message, Color.Blue);

        // ---------------------------------------------------------------
        // Shared: Validation helpers
        // ---------------------------------------------------------------

        /// <summary>
        /// Checks that a TextBox is not blank. Displays an error and focuses
        /// the control if validation fails.
        /// </summary>
        protected bool RequireField(TextBox field, string fieldName)
        {
            if (string.IsNullOrWhiteSpace(field.Text))
            {
                ShowError($"{fieldName} is required.");
                field.Focus();
                return false;
            }
            return true;
        }

        /// <summary>
        /// Validates a standard set of electrical-rating fields that both
        /// entry forms share (Part Number, Standard, IR Rating).
        /// Returns false and shows an error message on first failure.
        /// </summary>
        protected bool ValidateCommonFields(TextBox txtPartNumber,
                                            TextBox txtStandard,
                                            TextBox txtIRRating)
        {
            return RequireField(txtPartNumber, "Part Number")
                && RequireField(txtStandard, "Standard")
                && RequireField(txtIRRating, "IR Rating");
        }

        // ---------------------------------------------------------------
        // Shared: Database helpers
        // ---------------------------------------------------------------

        /// <summary>
        /// Returns the connection string named "PartsDatabase" from Web.config.
        /// </summary>
        protected string GetConnectionString()
        {
            return ConfigurationManager
                .ConnectionStrings["PartsDatabase"]
                .ConnectionString;
        }

        /// <summary>
        /// Opens a SqlConnection, executes <paramref name="addParameters"/> to
        /// populate the command, then runs ExecuteNonQuery.
        /// Returns the number of rows affected, or -1 on failure.
        /// Handles SqlException internally and surfaces a user-friendly message.
        /// </summary>
        protected int ExecuteNonQuery(string sql,
                                      Action<SqlCommand> addParameters)
        {
            try
            {
                using (var connection = new SqlConnection(GetConnectionString()))
                using (var command = new SqlCommand(sql, connection))
                {
                    addParameters(command);
                    connection.Open();
                    return command.ExecuteNonQuery();
                }
            }
            catch (SqlException sqlEx)
            {
                // Primary key / unique constraint violation
                if (sqlEx.Number == 2627)
                    ShowError("A part with this Part Number already exists.");
                else
                    ShowError("Database error: " + sqlEx.Message);

                return -1;
            }
            catch (Exception ex)
            {
                ShowError("Unexpected error: " + ex.Message);
                return -1;
            }
        }

        /// <summary>
        /// Convenience wrapper: returns a dash "-" when the value is blank,
        /// otherwise returns the trimmed value. Used for optional fields.
        /// </summary>
        protected static string DashIfBlank(string value)
            => string.IsNullOrWhiteSpace(value) ? "-" : value.Trim();
    }
}
