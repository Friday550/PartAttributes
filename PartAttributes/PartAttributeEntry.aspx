﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PartAttributeEntry.aspx.cs" Inherits="PartAttributes.PartAttributeEntry" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Part Attribute Entry</title>
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
            border-bottom: 2px solid #007acc;
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
            border-color: #007acc;
            outline: none;
            box-shadow: 0 0 5px rgba(0,122,204,0.3);
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="form-container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1 style="text-align: center; color: #333; margin: 0;">Part Attribute Entry Form</h1>
                <a href="ViewPartAttributes.aspx" style="padding: 10px 20px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 5px;">View Records</a>
            </div>
            
            <!-- Basic Information Section -->
            <div class="form-section">
                <div class="section-title">Basic Information</div>
                <div class="form-row">
                    <label for="txtPartNumber">Part Number <span class="required">*</span>:</label>
                    <asp:TextBox ID="txtPartNumber" runat="server" MaxLength="50" required="true"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtStandard">Standard <span class="required">*</span>:</label>
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

            <!-- Phase Configuration Section -->
            <div class="form-section">
                <div class="section-title">Phase Configuration <span style="font-size: 12px; color: #666;">(Blank fields will default to "-")</span></div>
                <div class="form-row">
                    <label for="txtPhaseConfig1">Phase Config 1:</label>
                    <asp:TextBox ID="txtPhaseConfig1" runat="server" MaxLength="50"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtPhaseConfig2">Phase Config 2:</label>
                    <asp:TextBox ID="txtPhaseConfig2" runat="server" MaxLength="50"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtPhaseConfig3">Phase Config 3:</label>
                    <asp:TextBox ID="txtPhaseConfig3" runat="server" MaxLength="50"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtPhaseConfig4">Phase Config 4:</label>
                    <asp:TextBox ID="txtPhaseConfig4" runat="server" MaxLength="50"></asp:TextBox>
                </div>
                <div class="form-row">
                    <label for="txtPhaseConfig5">Phase Config 5:</label>
                    <asp:TextBox ID="txtPhaseConfig5" runat="server" MaxLength="50"></asp:TextBox>
                </div>
            </div>

            <!-- Breaker Information Section -->
            <div class="form-section">
                <div class="section-title">Breaker Information <span style="font-size: 12px; color: #666;">(Blank fields will default to "-")</span></div>
                
                <!-- Breaker 1 -->
                <div style="background-color: #f0f8ff; padding: 10px; margin-bottom: 10px; border-radius: 4px;">
                    <strong>Breaker 1</strong>
                    <div class="form-row">
                        <label for="txtBreaker1">Breaker 1:</label>
                        <asp:TextBox ID="txtBreaker1" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker1Outlet">Breaker 1 Outlet:</label>
                        <asp:TextBox ID="txtBreaker1Outlet" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker1Amps">Breaker 1 Amps:</label>
                        <asp:TextBox ID="txtBreaker1Amps" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                </div>

                <!-- Breaker 2 -->
                <div style="background-color: #f0f8ff; padding: 10px; margin-bottom: 10px; border-radius: 4px;">
                    <strong>Breaker 2</strong>
                    <div class="form-row">
                        <label for="txtBreaker2">Breaker 2:</label>
                        <asp:TextBox ID="txtBreaker2" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker2Outlet">Breaker 2 Outlet:</label>
                        <asp:TextBox ID="txtBreaker2Outlet" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker2Amps">Breaker 2 Amps:</label>
                        <asp:TextBox ID="txtBreaker2Amps" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                </div>

                <!-- Breaker 3 -->
                <div style="background-color: #f0f8ff; padding: 10px; margin-bottom: 10px; border-radius: 4px;">
                    <strong>Breaker 3</strong>
                    <div class="form-row">
                        <label for="txtBreaker3">Breaker 3:</label>
                        <asp:TextBox ID="txtBreaker3" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker3Outlet">Breaker 3 Outlet:</label>
                        <asp:TextBox ID="txtBreaker3Outlet" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker3Amps">Breaker 3 Amps:</label>
                        <asp:TextBox ID="txtBreaker3Amps" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                </div>

                <!-- Breaker 4 -->
                <div style="background-color: #f0f8ff; padding: 10px; margin-bottom: 10px; border-radius: 4px;">
                    <strong>Breaker 4</strong>
                    <div class="form-row">
                        <label for="txtBreaker4">Breaker 4:</label>
                        <asp:TextBox ID="txtBreaker4" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker4Outlet">Breaker 4 Outlet:</label>
                        <asp:TextBox ID="txtBreaker4Outlet" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker4Amps">Breaker 4 Amps:</label>
                        <asp:TextBox ID="txtBreaker4Amps" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                </div>

                <!-- Breaker 5 -->
                <div style="background-color: #f0f8ff; padding: 10px; margin-bottom: 10px; border-radius: 4px;">
                    <strong>Breaker 5</strong>
                    <div class="form-row">
                        <label for="txtBreaker5">Breaker 5:</label>
                        <asp:TextBox ID="txtBreaker5" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker5Outlet">Breaker 5 Outlet:</label>
                        <asp:TextBox ID="txtBreaker5Outlet" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <label for="txtBreaker5Amps">Breaker 5 Amps:</label>
                        <asp:TextBox ID="txtBreaker5Amps" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
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
