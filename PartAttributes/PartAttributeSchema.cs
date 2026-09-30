using System;
using System.Data.SqlClient;

namespace PartAttributes
{
    /// <summary>
    /// Reports which optional tblPartAttribute columns are present so the pages
    /// keep working against databases where the breaker 6 columns have not been
    /// added yet. Only a positive result is cached, so adding the columns takes
    /// effect without recycling the app pool.
    /// </summary>
    internal static class PartAttributeSchema
    {
        private static bool _hasBreaker6;

        public static bool HasBreaker6(string connectionString)
        {
            if (!_hasBreaker6)
                _hasBreaker6 = ColumnExists(connectionString, "attrBreaker6");

            return _hasBreaker6;
        }

        private static bool ColumnExists(string connectionString, string columnName)
        {
            const string sql = "SELECT COL_LENGTH('dbo.tblPartAttribute', @ColumnName)";

            try
            {
                using (var connection = new SqlConnection(connectionString))
                using (var command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@ColumnName", columnName);
                    connection.Open();

                    object result = command.ExecuteScalar();
                    return result != null && result != DBNull.Value;
                }
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}
