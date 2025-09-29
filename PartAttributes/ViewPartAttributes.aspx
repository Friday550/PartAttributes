<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewPartAttributes.aspx.cs" Inherits="PartAttributes.ViewPartAttributes" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Part Attributes</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 1400px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #007acc;
        }
        .header h1 {
            color: #333;
            margin: 0;
        }
        .search-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 5px;
        }
        .search-row {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .search-row input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .btn {
            padding: 10px 25px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007acc;
            color: white;
        }
        .btn-primary:hover {
            background-color: #005a99;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .grid-container {
            overflow-x: auto;
        }
        .grid-view {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .grid-view th {
            background-color: #007acc;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: bold;
            position: sticky;
            top: 0;
        }
        .grid-view td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .grid-view tr:hover {
            background-color: #f5f5f5;
        }
        .grid-view tr:nth-child(even) {
            background-color: #fafafa;
        }
        .no-data {
            text-align: center;
            padding: 30px;
            color: #666;
            font-style: italic;
        }
        .status-message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            text-align: center;
            font-weight: bold;
        }
        .record-count {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 30px;
            border-radius: 8px;
            width: 400px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        .modal-header {
            font-size: 20px;
            font-weight: bold;
            color: #d9534f;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #d9534f;
        }
        .modal-body {
            margin-bottom: 20px;
        }
        .modal-body p {
            margin-bottom: 15px;
            color: #333;
        }
        .modal-body input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .modal-footer {
            text-align: right;
        }
        .btn-danger {
            background-color: #d9534f;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c9302c;
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
            margin-right: 10px;
        }
        .btn-cancel:hover {
            background-color: #545b62;
        }
        .delete-btn {
            background-color: #d9534f;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        .delete-btn:hover {
            background-color: #c9302c;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>Part Attributes Database</h1>
                <a href="PartAttributeEntry.aspx" class="btn btn-primary">+ Add New Part</a>
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblStatus" runat="server" CssClass="status-message"></asp:Label>

            <!-- Search Section -->
            <div class="search-section">
                <div class="search-row">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by Part Number or Standard..."></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnShowAll" runat="server" Text="Show All" CssClass="btn btn-secondary" OnClick="btnShowAll_Click" />
                </div>
            </div>

            <!-- Record Count -->
            <div class="record-count">
                <asp:Label ID="lblRecordCount" runat="server"></asp:Label>
            </div>

            <!-- GridView for displaying data -->
            <div class="grid-container">
                <asp:GridView ID="gvPartAttributes" runat="server" 
                    CssClass="grid-view"
                    AutoGenerateColumns="False"
                    AllowPaging="True"
                    PageSize="20"
                    OnPageIndexChanging="gvPartAttributes_PageIndexChanging"
                    OnRowDeleting="gvPartAttributes_RowDeleting"
                    DataKeyNames="attrPartNumber"
                    EmptyDataText="No part attributes found in the database.">
                    <Columns>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnDelete" runat="server" 
                                    Text="Delete" 
                                    CssClass="delete-btn"
                                    CommandName="Delete" 
                                    OnClientClick="return showDeleteModal(this);" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="attrPartNumber" HeaderText="Part Number" />
                        <asp:BoundField DataField="attrStandard" HeaderText="Standard" />
                        <asp:BoundField DataField="attrIRrating" HeaderText="IR Rating" />
                        <asp:BoundField DataField="attrRatedCurrent" HeaderText="Rated Current" />
                        <asp:BoundField DataField="attrRMSSym" HeaderText="RMS Sym" />
                        <asp:BoundField DataField="attrSystemVolts" HeaderText="System Volts" />
                        <asp:BoundField DataField="attrFrequency" HeaderText="Frequency" />
                        <asp:BoundField DataField="attrGround" HeaderText="Ground" />
                        <asp:BoundField DataField="attrPhaseConfig1" HeaderText="Phase 1" />
                        <asp:BoundField DataField="attrPhaseConfig2" HeaderText="Phase 2" />
                        <asp:BoundField DataField="attrPhaseConfig3" HeaderText="Phase 3" />
                        <asp:BoundField DataField="attrPhaseConfig4" HeaderText="Phase 4" />
                        <asp:BoundField DataField="attrPhaseConfig5" HeaderText="Phase 5" />
                        <asp:BoundField DataField="attrBreaker1" HeaderText="Breaker 1" />
                        <asp:BoundField DataField="attrBreaker1Outlet" HeaderText="B1 Outlet" />
                        <asp:BoundField DataField="attrBreaker1Amps" HeaderText="B1 Amps" />
                        <asp:BoundField DataField="attrBreaker2" HeaderText="Breaker 2" />
                        <asp:BoundField DataField="attrBreaker2Outlet" HeaderText="B2 Outlet" />
                        <asp:BoundField DataField="attrBreaker2Amps" HeaderText="B2 Amps" />
                        <asp:BoundField DataField="attrBreaker3" HeaderText="Breaker 3" />
                        <asp:BoundField DataField="attrBreaker3Outlet" HeaderText="B3 Outlet" />
                        <asp:BoundField DataField="attrBreaker3Amps" HeaderText="B3 Amps" />
                        <asp:BoundField DataField="attrBreaker4" HeaderText="Breaker 4" />
                        <asp:BoundField DataField="attrBreaker4Outlet" HeaderText="B4 Outlet" />
                        <asp:BoundField DataField="attrBreaker4Amps" HeaderText="B4 Amps" />
                        <asp:BoundField DataField="attrBreaker5" HeaderText="Breaker 5" />
                        <asp:BoundField DataField="attrBreaker5Outlet" HeaderText="B5 Outlet" />
                        <asp:BoundField DataField="attrBreaker5Amps" HeaderText="B5 Amps" />
                    </Columns>
                    <PagerStyle HorizontalAlign="Center" CssClass="pager" />
                </asp:GridView>
            </div>

            <!-- Delete Confirmation Modal -->
            <div id="deleteModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        Confirm Delete
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this part attribute?</p>
                        <p><strong>Part Number: <span id="partNumberDisplay"></span></strong></p>
                        <p>Enter password to confirm:</p>
                        <asp:TextBox ID="txtDeletePassword" runat="server" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                        <asp:HiddenField ID="hdnRowIndex" runat="server" />
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnCancelDelete" runat="server" Text="Cancel" CssClass="btn btn-cancel" OnClientClick="hideDeleteModal(); return false;" />
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete" CssClass="btn btn-danger" OnClick="btnConfirmDelete_Click" />
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            function showDeleteModal(button) {
                // Get the row
                var row = button.parentNode.parentNode;
                var partNumber = row.cells[1].innerText; // Part Number is in the second cell (index 1)
                
                // Store the row index
                var rowIndex = row.rowIndex - 1; // Subtract 1 for header row
                document.getElementById('<%= hdnRowIndex.ClientID %>').value = rowIndex;
                
                // Display the part number
                document.getElementById('partNumberDisplay').innerText = partNumber;
                
                // Clear password field
                document.getElementById('<%= txtDeletePassword.ClientID %>').value = '';
                
                // Show modal
                document.getElementById('deleteModal').style.display = 'block';
                
                return false; // Prevent postback
            }

            function hideDeleteModal() {
                document.getElementById('deleteModal').style.display = 'none';
                return false;
            }

            // Close modal when clicking outside of it
            window.onclick = function(event) {
                var modal = document.getElementById('deleteModal');
                if (event.target == modal) {
                    hideDeleteModal();
                }
            }
        </script>
    </form>
</body>
</html>