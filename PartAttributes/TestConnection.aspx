<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestConnection.aspx.cs" Inherits="PartAttributes.TestConnection" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Test SQL Connection</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>SQL Server Connection Test</h2>
            <asp:Button ID="btnTestConnection" runat="server" Text="Test Connection" OnClick="btnTestConnection_Click" />
            <br /><br />
            <asp:Label ID="lblResult" runat="server" Font-Size="14px"></asp:Label>
        </div>
    </form>
</body>
</html>
