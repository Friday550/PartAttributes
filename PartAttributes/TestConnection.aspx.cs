using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;

namespace PartAttributes
{

    public partial class TestConnection : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)  // Only run on first page load, not on button clicks
            {
                TestDatabaseConnection();
            }
        }

        private void TestDatabaseConnection()
        {
            string connectionString = "";

            try
            {
                connectionString = ConfigurationManager.ConnectionStrings["PartsDatabase"]?.ConnectionString;

                if (string.IsNullOrEmpty(connectionString))
                {
                    lblResult.Text = "❌ Connection string 'PartsDatabase' not found in web.config";
                    lblResult.ForeColor = Color.Red;
                    return;
                }

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    lblResult.Text = "✅ Connection successful! Server: " + connection.DataSource + ", Database: " + connection.Database;
                    lblResult.ForeColor = Color.Green;
                }
            }
            catch (Exception ex)
            {
                lblResult.Text = "❌ Connection failed: " + ex.Message;
                lblResult.ForeColor = Color.Red;
            }
        }

        protected void btnTestConnection_Click(object sender, EventArgs e)
        {
            TestDatabaseConnection();  // Button can still manually test
        }
    }
}