<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PartAttributeType2Entry.aspx.cs" Inherits="PartAttributes.PartAttributeType2Entry" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Part Attribute Entry - HPB</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 1200px;
            margin: 0 auto;
        }
        .form-section {
            margin-bottom: 25px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            background-color: #fafafa;
        }
        .section-title {
            font-weight: bold;
            font-size: 16px;
            color: #333;
            margin-bottom: 10px;
            border-bottom: 2px solid #28a745;
            padding-bottom: 5px;
        }
        .form-row {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }
        .form-row label {
            display: inline-block;
            width: 200px;
            font-weight: bold;
            margin-right: 10px;
            color: #555;
        }
        .form-row input, .form-row select {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-row input:focus, .form-row select:focus {
            border-color: #28a745;
            outline: none;
            box-shadow: 0 0 5px rgba(40,167,69,0.3);
        }
        .button-container {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        .btn {
            padding: 12px 30px;
            margin: 0 10px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-primary {
            background-color: #28a745;
            color: white;
        }
        .btn-primary:hover {
            background-color: #218838;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .status-message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
            text-align: center;
            font-weight: bold;
        }
        .required {
            color: red;
        }
        .nav-link {
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-left: 10px;
        }
        .nav-link:hover {
            background-color: #545b62;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="form-container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1 style="text-align: center; color: #333; margin: 0;">Part Attribute Entry - HPB</h1>
                <div>
                    <a href="PartAttributeEntry.aspx" class="nav-link">iMPB Entry</a>
                    <a href="ViewPartAttributes.aspx" class="nav-link">View Records</a>
                </div>
            </div>
            
            <!-- Basic Information Section -->
            <div class="form-section">
                <div class="section-title">Basic Information</div>
                <div class="form-row">
                    <label for="txtPartNumber">Part Number <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtPartNumber" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtStandard">Standard/Camlock<span class="required">*</span>:</label>
                    <asp:TextBox ID="txtStandard" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
            </div>

            <!-- Electrical Ratings Section -->
            <div class="form-section">
                <div class="section-title">Electrical Ratings</div>
                <div class="form-row">
                    <label for="txtIRRating">IR Rating <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtIRRating" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtRatedCurrent">Rated Current <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtRatedCurrent" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtRMSSym">RMS Sym <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtRMSSym" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtSystemVolts">System Volts <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtSystemVolts" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtFrequency">Frequency <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtFrequency" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtGround">Ground <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtGround" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
            </div>

            <!-- System Configuration Section (NEW) -->
            <div class="form-section">
                <div class="section-title">System Configuration <span style="font-size: 12px; color: #666;"></span></div>
                <div class="form-row">
                    <label for="txtSystemConfig">System Config/</br >Protection Device <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtSystemConfig" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtNeutral">Neutral <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtNeutral" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
            </div>

            <!-- Buttons -->
            <div class="button-container">
                <asp:Button ID="btnSave" runat="server" Text="Save Part Attribute" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear Form" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
            </div>

            <!-- Status Message -->
            <div>
                <asp:Label ID="lblStatus" runat="server" CssClass="status-message"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>
