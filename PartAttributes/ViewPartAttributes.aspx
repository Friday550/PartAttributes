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
        .header h1 { color: #333; margin: 0; }
        .search-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 5px;
        }
        .search-row { display: flex; gap: 10px; align-items: center; }
        .search-row input {
            flex: 1; padding: 8px;
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
        .btn-primary  { background-color: #007acc; color: white; }
        .btn-primary:hover  { background-color: #005a99; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #545b62; }
        .grid-container { overflow-x: auto; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .grid-view th {
            background-color: #007acc; color: white;
            padding: 12px; text-align: left;
            font-weight: bold; position: sticky; top: 0;
        }
        .grid-view td { padding: 10px; border-bottom: 1px solid #ddd; }
        .grid-view tr:hover { background-color: #f5f5f5; }
        .grid-view tr:nth-child(even) { background-color: #fafafa; }
        .status-message {
            padding: 10px; margin-bottom: 15px;
            border-radius: 4px; text-align: center; font-weight: bold;
        }
        .record-count { color: #666; font-size: 14px; margin-bottom: 10px; }

        /* ── Actions button ── */
        .actions-btn {
            background-color: #007acc; color: white;
            border: none; padding: 5px 15px;
            border-radius: 4px; cursor: pointer; font-size: 12px;
        }
        .actions-btn:hover { background-color: #005a99; }

        /* ── Modal backdrop ── */
        .modal {
            display: none; position: fixed;
            z-index: 1000; left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow-y: auto;
        }

        /* ── Modal shell ── */
        .modal-content {
            background-color: white;
            margin: 40px auto; padding: 0;
            border-radius: 8px; width: 520px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .modal-header {
            background-color: #007acc; color: white;
            padding: 16px 24px; font-size: 18px; font-weight: bold;
            display: flex; justify-content: space-between; align-items: center;
        }
        .modal-header .part-label { font-size: 13px; font-weight: normal; opacity: 0.85; }
        .modal-close {
            background: none; border: none; color: white;
            font-size: 20px; cursor: pointer; line-height: 1;
        }
        .modal-close:hover { opacity: 0.7; }

        /* ── Action tiles ── */
        .modal-actions { display: flex; gap: 12px; padding: 24px; }
        .action-tile {
            flex: 1; display: flex; flex-direction: column;
            align-items: center; gap: 8px; padding: 20px 10px;
            border: 2px solid #e0e0e0; border-radius: 8px;
            background: #fafafa; cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
            font-size: 13px; font-weight: bold; color: #333; text-align: center;
        }
        .action-tile:hover { background: #f0f0f0; }
        .action-tile .tile-icon { font-size: 28px; line-height: 1; }
        .action-tile.edit-tile:hover    { border-color: #007acc; color: #007acc; }
        .action-tile.preview-tile:hover { border-color: #6c757d; color: #6c757d; }
        .action-tile.delete-tile:hover  { border-color: #d9534f; color: #d9534f; }

        /* ── Shared panel base ── */
        .panel { display: none; padding: 0 24px 24px; }
        .back-btn {
            background: none; border: none; color: #007acc;
            cursor: pointer; font-size: 13px;
            padding: 12px 0; display: flex; align-items: center; gap: 4px;
        }
        .back-btn:hover { text-decoration: underline; }

        /* ── Edit panel ── */
        .edit-section-title {
            font-weight: bold; font-size: 13px; color: #007acc;
            border-bottom: 1px solid #c8e0f4;
            padding-bottom: 4px; margin: 14px 0 10px;
        }
        .edit-form-row {
            display: flex; align-items: center;
            margin-bottom: 8px; gap: 10px;
        }
        .edit-form-row label {
            width: 140px; font-size: 12px; font-weight: bold;
            color: #555; flex-shrink: 0;
        }
        /* Target ASP TextBox rendered inputs inside edit panel */
        #panelEdit input[type="text"],
        #panelEdit input[type="password"] {
            flex: 1; padding: 6px 8px;
            border: 1px solid #ccc; border-radius: 4px;
            font-size: 13px; box-sizing: border-box;
        }
        #panelEdit input[type="text"]:focus {
            border-color: #007acc; outline: none;
            box-shadow: 0 0 4px rgba(0,122,204,0.3);
        }
        .part-number-note {
            font-size: 11px; color: #e07000;
            margin: -4px 0 10px 150px; font-style: italic;
        }
        .edit-save-btn {
            width: 100%; padding: 11px;
            background-color: #007acc; color: white;
            border: none; border-radius: 5px;
            font-size: 14px; cursor: pointer; margin-top: 10px;
        }
        .edit-save-btn:hover { background-color: #005a99; }

        /* ── Delete panel ── */
        .delete-panel-body p { color: #333; font-size: 14px; margin: 0 0 10px; }
        #panelDelete input[type="password"] {
            width: 100%; padding: 10px;
            border: 1px solid #ccc; border-radius: 4px;
            font-size: 14px; box-sizing: border-box; margin-bottom: 14px;
        }
        .delete-confirm-btn {
            width: 100%; padding: 11px;
            background-color: #d9534f; color: white;
            border: none; border-radius: 5px;
            font-size: 14px; cursor: pointer;
        }
        .delete-confirm-btn:hover { background-color: #c9302c; }

        /* ── Preview panel ── */
        .preview-placeholder {
            text-align: center; padding: 30px 0 10px;
            color: #999; font-size: 14px; font-style: italic;
        }
        .preview-placeholder .preview-icon { font-size: 40px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>Part Attributes Database</h1>
                <div>
                    <a href="PartAttributeEntry.aspx"      class="btn btn-primary" style="margin-right:10px;">+ Add IMPB Part</a>
                    <a href="PartAttributeType2Entry.aspx" class="btn btn-primary" style="background-color:#28a745;">+ Add HPB Part</a>
                </div>
            </div>

            <asp:Label ID="lblStatus" runat="server" CssClass="status-message"></asp:Label>

            <div class="search-section">
                <div class="search-row">
                    <asp:TextBox ID="txtSearch"  runat="server" placeholder="Search by Part Number or Standard..."></asp:TextBox>
                    <asp:Button  ID="btnSearch"  runat="server" Text="Search"   CssClass="btn btn-primary"   OnClick="btnSearch_Click" />
                    <asp:Button  ID="btnShowAll" runat="server" Text="Show All" CssClass="btn btn-secondary" OnClick="btnShowAll_Click" />
                </div>
            </div>

            <div class="record-count">
                <asp:Label ID="lblRecordCount" runat="server"></asp:Label>
            </div>

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
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <button type="button" class="actions-btn" onclick="showActionsModal(this);">
                                    &#9776; Actions
                                </button>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="attrPartNumber"    HeaderText="Part Number" />
                        <asp:BoundField DataField="attrStandard"      HeaderText="Standard" />
                        <asp:BoundField DataField="attrIRrating"      HeaderText="IR Rating" />
                        <asp:BoundField DataField="attrRatedCurrent"  HeaderText="Rated Current" />
                        <asp:BoundField DataField="attrRMSSym"        HeaderText="RMS Sym" />
                        <asp:BoundField DataField="attrSystemVolts"   HeaderText="System Volts" />
                        <asp:BoundField DataField="attrFrequency"     HeaderText="Frequency" />
                        <asp:BoundField DataField="attrGround"        HeaderText="Ground" />
                        <asp:BoundField DataField="attrNeutral"       HeaderText="Neutral" />
                        <asp:BoundField DataField="attrSystemConfig"  HeaderText="System Config" />
                        <asp:BoundField DataField="attrPhaseConfig1"  HeaderText="Phase 1" />
                        <asp:BoundField DataField="attrPhaseConfig2"  HeaderText="Phase 2" />
                        <asp:BoundField DataField="attrPhaseConfig3"  HeaderText="Phase 3" />
                        <asp:BoundField DataField="attrPhaseConfig4"  HeaderText="Phase 4" />
                        <asp:BoundField DataField="attrPhaseConfig5"  HeaderText="Phase 5" />
                        <asp:BoundField DataField="attrBreaker1"       HeaderText="Breaker 1" />
                        <asp:BoundField DataField="attrBreaker1Outlet" HeaderText="B1 Outlet" />
                        <asp:BoundField DataField="attrBreaker1Amps"   HeaderText="B1 Amps" />
                        <asp:BoundField DataField="attrBreaker2"       HeaderText="Breaker 2" />
                        <asp:BoundField DataField="attrBreaker2Outlet" HeaderText="B2 Outlet" />
                        <asp:BoundField DataField="attrBreaker2Amps"   HeaderText="B2 Amps" />
                        <asp:BoundField DataField="attrBreaker3"       HeaderText="Breaker 3" />
                        <asp:BoundField DataField="attrBreaker3Outlet" HeaderText="B3 Outlet" />
                        <asp:BoundField DataField="attrBreaker3Amps"   HeaderText="B3 Amps" />
                        <asp:BoundField DataField="attrBreaker4"       HeaderText="Breaker 4" />
                        <asp:BoundField DataField="attrBreaker4Outlet" HeaderText="B4 Outlet" />
                        <asp:BoundField DataField="attrBreaker4Amps"   HeaderText="B4 Amps" />
                        <asp:BoundField DataField="attrBreaker5"       HeaderText="Breaker 5" />
                        <asp:BoundField DataField="attrBreaker5Outlet" HeaderText="B5 Outlet" />
                        <asp:BoundField DataField="attrBreaker5Amps"   HeaderText="B5 Amps" />
                    </Columns>
                    <PagerStyle HorizontalAlign="Center" CssClass="pager" />
                </asp:GridView>
            </div>

            <!-- ═══════════════════════════════════════
                 ACTIONS MODAL
            ════════════════════════════════════════ -->
            <div id="actionsModal" class="modal">
                <div class="modal-content">

                    <div class="modal-header">
                        <div>
                            Actions
                            <div class="part-label" id="modalPartLabel"></div>
                        </div>
                        <button type="button" class="modal-close" onclick="hideActionsModal()">&#x2715;</button>
                    </div>

                    <%-- Hidden fields used by server-side handlers --%>
                    <asp:HiddenField ID="hdnRowIndex"       runat="server" />
                    <asp:HiddenField ID="hdnOrigPartNumber" runat="server" />

                    <!-- Tiles -->
                    <div id="panelTiles" class="modal-actions">
                        <div class="action-tile edit-tile"    onclick="showPanel('edit')">
                            <span class="tile-icon">&#9998;</span>Edit
                        </div>
                        <div class="action-tile preview-tile" onclick="showPanel('preview')">
                            <span class="tile-icon">&#128065;</span>Preview
                        </div>
                        <div class="action-tile delete-tile"  onclick="showPanel('delete')">
                            <span class="tile-icon">&#128465;</span>Delete
                        </div>
                    </div>

                    <!-- Edit panel -->
                    <div id="panelEdit" class="panel">
                        <button type="button" class="back-btn" onclick="showPanel('tiles')">&#8592; Back</button>

                        <div class="edit-section-title">Basic Information</div>
                        <div class="edit-form-row">
                            <label>Part Number:</label>
                            <asp:TextBox ID="editPartNumber" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="part-number-note">⚠ Changing this updates the primary key.</div>
                        <div class="edit-form-row">
                            <label>Standard:</label>
                            <asp:TextBox ID="editStandard" runat="server" MaxLength="50"></asp:TextBox>
                        </div>

                        <div class="edit-section-title">Electrical Ratings</div>
                        <div class="edit-form-row">
                            <label>IR Rating:</label>
                            <asp:TextBox ID="editIRRating" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Rated Current:</label>
                            <asp:TextBox ID="editRatedCurrent" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>RMS Sym:</label>
                            <asp:TextBox ID="editRMSSym" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>System Volts:</label>
                            <asp:TextBox ID="editSystemVolts" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Frequency:</label>
                            <asp:TextBox ID="editFrequency" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Ground:</label>
                            <asp:TextBox ID="editGround" runat="server" MaxLength="50"></asp:TextBox>
                        </div>

                        <div class="edit-section-title">System Configuration</div>
                        <div class="edit-form-row">
                            <label>System Config:</label>
                            <asp:TextBox ID="editSystemConfig" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Neutral:</label>
                            <asp:TextBox ID="editNeutral" runat="server" MaxLength="50"></asp:TextBox>
                        </div>

                        <div class="edit-section-title">Phase Configuration</div>
                        <div class="edit-form-row">
                            <label>Phase Config 1:</label>
                            <asp:TextBox ID="editPhaseConfig1" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Phase Config 2:</label>
                            <asp:TextBox ID="editPhaseConfig2" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Phase Config 3:</label>
                            <asp:TextBox ID="editPhaseConfig3" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Phase Config 4:</label>
                            <asp:TextBox ID="editPhaseConfig4" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Phase Config 5:</label>
                            <asp:TextBox ID="editPhaseConfig5" runat="server" MaxLength="50"></asp:TextBox>
                        </div>

                        <div class="edit-section-title">Breaker Information</div>
                        <div class="edit-form-row">
                            <label>Breaker 1:</label>
                            <asp:TextBox ID="editBreaker1" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B1 Outlet:</label>
                            <asp:TextBox ID="editBreaker1Outlet" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B1 Amps:</label>
                            <asp:TextBox ID="editBreaker1Amps" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Breaker 2:</label>
                            <asp:TextBox ID="editBreaker2" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B2 Outlet:</label>
                            <asp:TextBox ID="editBreaker2Outlet" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B2 Amps:</label>
                            <asp:TextBox ID="editBreaker2Amps" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Breaker 3:</label>
                            <asp:TextBox ID="editBreaker3" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B3 Outlet:</label>
                            <asp:TextBox ID="editBreaker3Outlet" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B3 Amps:</label>
                            <asp:TextBox ID="editBreaker3Amps" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Breaker 4:</label>
                            <asp:TextBox ID="editBreaker4" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B4 Outlet:</label>
                            <asp:TextBox ID="editBreaker4Outlet" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B4 Amps:</label>
                            <asp:TextBox ID="editBreaker4Amps" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>Breaker 5:</label>
                            <asp:TextBox ID="editBreaker5" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B5 Outlet:</label>
                            <asp:TextBox ID="editBreaker5Outlet" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="edit-form-row">
                            <label>B5 Amps:</label>
                            <asp:TextBox ID="editBreaker5Amps" runat="server" MaxLength="50"></asp:TextBox>
                        </div>

                        <asp:Button ID="btnSaveEdit" runat="server"
                            Text="Save Changes"
                            CssClass="edit-save-btn"
                            OnClick="btnSaveEdit_Click" />
                    </div>

                    <!-- Preview panel -->
                    <div id="panelPreview" class="panel">
                        <button type="button" class="back-btn" onclick="showPanel('tiles')">&#8592; Back</button>
                        <div class="preview-placeholder">
                            <div class="preview-icon">&#128196;</div>
                            Preview functionality coming soon.
                        </div>
                    </div>

                    <!-- Delete panel -->
                    <div id="panelDelete" class="panel">
                        <button type="button" class="back-btn" onclick="showPanel('tiles')">&#8592; Back</button>
                        <div class="delete-panel-body">
                            <p>Are you sure you want to permanently delete this part?</p>
                            <p>Enter the admin password to confirm:</p>
                            <asp:TextBox ID="txtDeletePassword" runat="server" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                            <asp:Button  ID="btnConfirmDelete"  runat="server"
                                Text="Confirm Delete"
                                CssClass="delete-confirm-btn"
                                OnClick="btnConfirmDelete_Click" />
                        </div>
                    </div>

                </div>
            </div>
            <%-- end actionsModal --%>

        </div>

        <script type="text/javascript">
            // Maps each field to its GridView column index (col 0 = Actions button)
            var COL = {
                partNumber: 1,
                standard: 2,
                irRating: 3,
                ratedCurrent: 4,
                rmsSym: 5,
                systemVolts: 6,
                frequency: 7,
                ground: 8,
                neutral: 9,
                systemConfig: 10,
                phaseConfig1: 11,
                phaseConfig2: 12,
                phaseConfig3: 13,
                phaseConfig4: 14,
                phaseConfig5: 15,
                breaker1: 16,
                breaker1Outlet: 17,
                breaker1Amps: 18,
                breaker2: 19,
                breaker2Outlet: 20,
                breaker2Amps: 21,
                breaker3: 22,
                breaker3Outlet: 23,
                breaker3Amps: 24,
                breaker4: 25,
                breaker4Outlet: 26,
                breaker4Amps: 27,
                breaker5: 28,
                breaker5Outlet: 29,
                breaker5Amps: 30
            };

            function cell(row, idx) {
                var c = row.cells[idx];
                return c ? c.innerText.trim() : '';
            }

            function fill(clientId, value) {
                var el = document.getElementById(clientId);
                if (el) el.value = value;
            }

            function showActionsModal(btn) {
                var row = btn.closest('tr');
                var partNumber = cell(row, COL.partNumber);

                // Pass identifiers to server
                fill('<%= hdnRowIndex.ClientID %>', (row.rowIndex - 1).toString());
                fill('<%= hdnOrigPartNumber.ClientID %>', partNumber);

                // Modal header subtitle
                document.getElementById('modalPartLabel').innerText = 'Part: ' + partNumber;

                // Populate every edit field directly from the grid row
                fill('<%= editPartNumber.ClientID %>', partNumber);
                fill('<%= editStandard.ClientID %>', cell(row, COL.standard));
                fill('<%= editIRRating.ClientID %>', cell(row, COL.irRating));
                fill('<%= editRatedCurrent.ClientID %>', cell(row, COL.ratedCurrent));
                fill('<%= editRMSSym.ClientID %>', cell(row, COL.rmsSym));
                fill('<%= editSystemVolts.ClientID %>', cell(row, COL.systemVolts));
                fill('<%= editFrequency.ClientID %>', cell(row, COL.frequency));
                fill('<%= editGround.ClientID %>', cell(row, COL.ground));
                fill('<%= editNeutral.ClientID %>', cell(row, COL.neutral));
                fill('<%= editSystemConfig.ClientID %>', cell(row, COL.systemConfig));
                fill('<%= editPhaseConfig1.ClientID %>', cell(row, COL.phaseConfig1));
                fill('<%= editPhaseConfig2.ClientID %>', cell(row, COL.phaseConfig2));
                fill('<%= editPhaseConfig3.ClientID %>', cell(row, COL.phaseConfig3));
                fill('<%= editPhaseConfig4.ClientID %>', cell(row, COL.phaseConfig4));
                fill('<%= editPhaseConfig5.ClientID %>', cell(row, COL.phaseConfig5));
                fill('<%= editBreaker1.ClientID %>',       cell(row, COL.breaker1));
                fill('<%= editBreaker1Outlet.ClientID %>', cell(row, COL.breaker1Outlet));
                fill('<%= editBreaker1Amps.ClientID %>',   cell(row, COL.breaker1Amps));
                fill('<%= editBreaker2.ClientID %>',       cell(row, COL.breaker2));
                fill('<%= editBreaker2Outlet.ClientID %>', cell(row, COL.breaker2Outlet));
                fill('<%= editBreaker2Amps.ClientID %>',   cell(row, COL.breaker2Amps));
                fill('<%= editBreaker3.ClientID %>',       cell(row, COL.breaker3));
                fill('<%= editBreaker3Outlet.ClientID %>', cell(row, COL.breaker3Outlet));
                fill('<%= editBreaker3Amps.ClientID %>',   cell(row, COL.breaker3Amps));
                fill('<%= editBreaker4.ClientID %>',       cell(row, COL.breaker4));
                fill('<%= editBreaker4Outlet.ClientID %>', cell(row, COL.breaker4Outlet));
                fill('<%= editBreaker4Amps.ClientID %>',   cell(row, COL.breaker4Amps));
                fill('<%= editBreaker5.ClientID %>',       cell(row, COL.breaker5));
                fill('<%= editBreaker5Outlet.ClientID %>', cell(row, COL.breaker5Outlet));
                fill('<%= editBreaker5Amps.ClientID %>',   cell(row, COL.breaker5Amps));

                // Reset delete password, open on tiles
                fill('<%= txtDeletePassword.ClientID %>', '');
                showPanel('tiles');
                document.getElementById('actionsModal').style.display = 'block';
            }

            function hideActionsModal() {
                document.getElementById('actionsModal').style.display = 'none';
                fill('<%= txtDeletePassword.ClientID %>', '');
            }

            function showPanel(name) {
                ['panelTiles', 'panelEdit', 'panelPreview', 'panelDelete'].forEach(function (id) {
                    document.getElementById(id).style.display = 'none';
                });
                var target = {
                    tiles: 'panelTiles', edit: 'panelEdit',
                    preview: 'panelPreview', delete: 'panelDelete'
                }[name];
                if (target) {
                    document.getElementById(target).style.display =
                        (name === 'tiles') ? 'flex' : 'block';
                }
            }

            window.onclick = function (e) {
                var modal = document.getElementById('actionsModal');
                if (e.target === modal) hideActionsModal();
            };
        </script>
    </form>
</body>
</html>



