<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewPartAttributes.aspx.cs" Inherits="PartAttributes.ViewPartAttributes" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Part Attributes</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container {
            background-color: white; padding: 30px; border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 1400px; margin: 0 auto;
        }
        .header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #007acc;
        }
        .header h1 { color: #333; margin: 0; }
        .search-section { margin-bottom: 20px; padding: 15px; background-color: #f9f9f9; border-radius: 5px; }
        .search-row { display: flex; gap: 10px; align-items: center; }
        .search-row input { flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        .btn { padding: 10px 25px; font-size: 14px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary  { background-color: #007acc; color: white; }
        .btn-primary:hover  { background-color: #005a99; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #545b62; }
        .grid-container { overflow-x: auto; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .grid-view th { background-color: #007acc; color: white; padding: 12px; text-align: left; font-weight: bold; position: sticky; top: 0; }
        .grid-view td { padding: 10px; border-bottom: 1px solid #ddd; }
        .grid-view tr:hover { background-color: #f5f5f5; }
        .grid-view tr:nth-child(even) { background-color: #fafafa; }
        .status-message { padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center; font-weight: bold; }
        .record-count { color: #666; font-size: 14px; margin-bottom: 10px; }
        .actions-btn { background-color: #007acc; color: white; border: none; padding: 5px 15px; border-radius: 4px; cursor: pointer; font-size: 12px; }
        .actions-btn:hover { background-color: #005a99; }

        /* ── Modal backdrop ── */
        .modal {
            display: none; position: fixed; z-index: 1000;
            left: 0; top: 0; width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.5); overflow-y: auto;
        }

        /* ── Modal shell — width expands when preview is active ── */
        .modal-content {
            background-color: white; margin: 40px auto; padding: 0;
            border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            overflow: hidden;
            width: 520px;              /* default */
            transition: width 0.25s ease;
        }
        .modal-content.preview-wide { width: 580px; }

        .modal-header {
            background-color: #007acc; color: white;
            padding: 16px 24px; font-size: 18px; font-weight: bold;
            display: flex; justify-content: space-between; align-items: center;
        }
        .modal-header .part-label { font-size: 13px; font-weight: normal; opacity: 0.85; }
        .modal-close { background: none; border: none; color: white; font-size: 20px; cursor: pointer; line-height: 1; }
        .modal-close:hover { opacity: 0.7; }

        /* ── Action tiles ── */
        .modal-actions { display: flex; gap: 12px; padding: 24px; }
        .action-tile {
            flex: 1; display: flex; flex-direction: column; align-items: center;
            gap: 8px; padding: 20px 10px; border: 2px solid #e0e0e0; border-radius: 8px;
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
            background: none; border: none; color: #007acc; cursor: pointer;
            font-size: 13px; padding: 12px 0; display: flex; align-items: center; gap: 4px;
        }
        .back-btn:hover { text-decoration: underline; }

        /* ── Edit panel ── */
        .edit-section-title {
            font-weight: bold; font-size: 13px; color: #007acc;
            border-bottom: 1px solid #c8e0f4; padding-bottom: 4px; margin: 14px 0 10px;
        }
        .edit-form-row { display: flex; align-items: center; margin-bottom: 8px; gap: 10px; }
        .edit-form-row label { width: 140px; font-size: 12px; font-weight: bold; color: #555; flex-shrink: 0; }
        #panelEdit input[type="text"], #panelEdit input[type="password"] {
            flex: 1; padding: 6px 8px; border: 1px solid #ccc;
            border-radius: 4px; font-size: 13px; box-sizing: border-box;
        }
        #panelEdit input[type="text"]:focus { border-color: #007acc; outline: none; box-shadow: 0 0 4px rgba(0,122,204,0.3); }
        .part-number-note { font-size: 11px; color: #e07000; margin: -4px 0 10px 150px; font-style: italic; }
        .edit-save-btn { width: 100%; padding: 11px; background-color: #007acc; color: white; border: none; border-radius: 5px; font-size: 14px; cursor: pointer; margin-top: 10px; }
        .edit-save-btn:hover { background-color: #005a99; }

        /* ── Delete panel ── */
        .delete-panel-body p { color: #333; font-size: 14px; margin: 0 0 10px; }
        #panelDelete input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; box-sizing: border-box; margin-bottom: 14px; }
        .delete-confirm-btn { width: 100%; padding: 11px; background-color: #d9534f; color: white; border: none; border-radius: 5px; font-size: 14px; cursor: pointer; }
        .delete-confirm-btn:hover { background-color: #c9302c; }

        /* ── Preview panel ── */

        /* Template picker grid */
        .template-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 20px;
        }
        .template-tile {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 14px 10px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
            background: #fafafa;
        }
        .template-tile:hover:not(.disabled) { border-color: #007acc; background: #f0f7ff; }
        .template-tile.active { border-color: #007acc; background: #e8f4ff; }
        .template-tile.disabled { opacity: 0.45; cursor: not-allowed; }
        .template-tile .t-name { font-weight: bold; font-size: 13px; color: #333; margin-bottom: 4px; }
        .template-tile .t-size { font-size: 11px; color: #888; }
        .template-tile .t-badge {
            display: inline-block; margin-top: 6px;
            font-size: 10px; padding: 2px 7px;
            border-radius: 10px; font-weight: bold;
        }
        .t-badge.ready    { background: #d4edda; color: #155724; }
        .t-badge.soon     { background: #e2e3e5; color: #6c757d; }

        /* iframe preview area */
        .preview-frame-wrap {
            display: none;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }
        .preview-frame-wrap.visible { display: flex; }

        .preview-frame-toolbar {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .preview-frame-label {
            font-size: 12px; font-weight: bold; color: #555;
        }
        .btn-print-label {
            padding: 7px 18px; font-size: 13px;
            background: #007acc; color: white;
            border: none; border-radius: 5px; cursor: pointer;
        }
        .btn-print-label:hover { background: #005a99; }

        #labelIframe {
            border: 1px solid #ccc;
            border-radius: 4px;
            background: #b0b0b0;
            /* label 240x576 scaled 2x = 480x1152, plus label page body padding */
            width:  520px;
            height: 1240px;
        }
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

            <%-- ═══════════════════════════════════
                 ACTIONS MODAL
            ════════════════════════════════════ --%>
            <div id="actionsModal" class="modal">
                <div class="modal-content" id="modalContent">

                    <div class="modal-header">
                        <div>
                            Actions
                            <div class="part-label" id="modalPartLabel"></div>
                        </div>
                        <button type="button" class="modal-close" onclick="hideActionsModal()">&#x2715;</button>
                    </div>

                    <asp:HiddenField ID="hdnRowIndex"       runat="server" />
                    <asp:HiddenField ID="hdnOrigPartNumber" runat="server" />

                    <%-- ── Panel: Tiles ── --%>
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

                    <%-- ── Panel: Edit ── --%>
                    <div id="panelEdit" class="panel">
                        <button type="button" class="back-btn" onclick="showPanel('tiles')">&#8592; Back</button>

                        <div class="edit-section-title">Basic Information</div>
                        <div class="edit-form-row">
                            <label>Part Number:</label>
                            <asp:TextBox ID="editPartNumber" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="part-number-note">&#9888; Changing this updates the primary key.</div>
                        <div class="edit-form-row">
                            <label>Standard:</label>
                            <asp:TextBox ID="editStandard" runat="server" MaxLength="50"></asp:TextBox>
                        </div>

                        <div class="edit-section-title">Electrical Ratings</div>
                        <div class="edit-form-row"><label>IR Rating:</label>      <asp:TextBox ID="editIRRating"     runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Rated Current:</label>  <asp:TextBox ID="editRatedCurrent" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>RMS Sym:</label>        <asp:TextBox ID="editRMSSym"       runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>System Volts:</label>   <asp:TextBox ID="editSystemVolts"  runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Frequency:</label>      <asp:TextBox ID="editFrequency"    runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Ground:</label>         <asp:TextBox ID="editGround"       runat="server" MaxLength="50"></asp:TextBox></div>

                        <div class="edit-section-title">System Configuration</div>
                        <div class="edit-form-row"><label>System Config:</label>  <asp:TextBox ID="editSystemConfig" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Neutral:</label>        <asp:TextBox ID="editNeutral"      runat="server" MaxLength="50"></asp:TextBox></div>

                        <div class="edit-section-title">Phase Configuration</div>
                        <div class="edit-form-row"><label>Phase Config 1:</label> <asp:TextBox ID="editPhaseConfig1" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Phase Config 2:</label> <asp:TextBox ID="editPhaseConfig2" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Phase Config 3:</label> <asp:TextBox ID="editPhaseConfig3" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Phase Config 4:</label> <asp:TextBox ID="editPhaseConfig4" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Phase Config 5:</label> <asp:TextBox ID="editPhaseConfig5" runat="server" MaxLength="50"></asp:TextBox></div>

                        <div class="edit-section-title">Breaker Information</div>
                        <div class="edit-form-row"><label>Breaker 1:</label>  <asp:TextBox ID="editBreaker1"       runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B1 Outlet:</label>  <asp:TextBox ID="editBreaker1Outlet" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B1 Amps:</label>    <asp:TextBox ID="editBreaker1Amps"   runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Breaker 2:</label>  <asp:TextBox ID="editBreaker2"       runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B2 Outlet:</label>  <asp:TextBox ID="editBreaker2Outlet" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B2 Amps:</label>    <asp:TextBox ID="editBreaker2Amps"   runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Breaker 3:</label>  <asp:TextBox ID="editBreaker3"       runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B3 Outlet:</label>  <asp:TextBox ID="editBreaker3Outlet" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B3 Amps:</label>    <asp:TextBox ID="editBreaker3Amps"   runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Breaker 4:</label>  <asp:TextBox ID="editBreaker4"       runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B4 Outlet:</label>  <asp:TextBox ID="editBreaker4Outlet" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B4 Amps:</label>    <asp:TextBox ID="editBreaker4Amps"   runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>Breaker 5:</label>  <asp:TextBox ID="editBreaker5"       runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B5 Outlet:</label>  <asp:TextBox ID="editBreaker5Outlet" runat="server" MaxLength="50"></asp:TextBox></div>
                        <div class="edit-form-row"><label>B5 Amps:</label>    <asp:TextBox ID="editBreaker5Amps"   runat="server" MaxLength="50"></asp:TextBox></div>

                        <asp:Button ID="btnSaveEdit" runat="server" Text="Save Changes" CssClass="edit-save-btn" OnClick="btnSaveEdit_Click" />
                    </div>

                    <%-- ── Panel: Preview ── --%>
                    <div id="panelPreview" class="panel">
                        <button type="button" class="back-btn" onclick="showPanel('tiles')">&#8592; Back</button>

                        <%-- Template picker --%>
                        <div class="template-grid" id="templateGrid">

                            <div class="template-tile" id="tileIMPB" onclick="loadTemplate('IMPB')">
                                <div class="t-name">IMPB</div>
                                <div class="t-size">2.5&quot; &times; 6&quot; &bull; Vertical</div>
                                <span class="t-badge ready">&#10003; Ready</span>
                            </div>

                            <div class="template-tile disabled" title="Coming soon">
                                <div class="t-name">MTS</div>
                                <div class="t-size">2.5&quot; &times; 6&quot; &bull; Horizontal</div>
                                <span class="t-badge soon">Coming Soon</span>
                            </div>

                            <div class="template-tile disabled" title="Coming soon">
                                <div class="t-name">HPB</div>
                                <div class="t-size">2.5&quot; &times; 6&quot; &bull; Horizontal</div>
                                <span class="t-badge soon">Coming Soon</span>
                            </div>

                            <div class="template-tile disabled" title="Coming soon">
                                <div class="t-name">G-BOX</div>
                                <div class="t-size">2.5&quot; &times; 6&quot; &bull; Horizontal</div>
                                <span class="t-badge soon">Coming Soon</span>
                            </div>
                        </div>

                        <%-- Label iframe (shown after template selected) --%>
                        <div class="preview-frame-wrap" id="previewFrameWrap">
                            <div class="preview-frame-toolbar">
                                <span class="preview-frame-label" id="previewFrameLabel"></span>
                                <button type="button" class="btn-print-label" onclick="printLabel()">
                                    &#128438; Print Label
                                </button>
                            </div>
                            <iframe id="labelIframe" src="about:blank" scrolling="no" frameborder="0"></iframe>
                        </div>
                    </div>

                    <%-- ── Panel: Delete ── --%>
                    <div id="panelDelete" class="panel">
                        <button type="button" class="back-btn" onclick="showPanel('tiles')">&#8592; Back</button>
                        <div class="delete-panel-body">
                            <p>Are you sure you want to permanently delete this part?</p>
                            <p>Enter the admin password to confirm:</p>
                            <asp:TextBox ID="txtDeletePassword" runat="server" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                            <asp:Button  ID="btnConfirmDelete"  runat="server" Text="Confirm Delete" CssClass="delete-confirm-btn" OnClick="btnConfirmDelete_Click" />
                        </div>
                    </div>

                </div>
            </div>
            <%-- end actionsModal --%>

        </div>

        <script type="text/javascript">

            // ── Column index map (col 0 = Actions button) ──────────────────
            var COL = {
                partNumber: 1, standard: 2, irRating: 3, ratedCurrent: 4,
                rmsSym: 5, systemVolts: 6, frequency: 7, ground: 8,
                neutral: 9, systemConfig: 10,
                phaseConfig1: 11, phaseConfig2: 12, phaseConfig3: 13,
                phaseConfig4: 14, phaseConfig5: 15,
                breaker1: 16, breaker1Outlet: 17, breaker1Amps: 18,
                breaker2: 19, breaker2Outlet: 20, breaker2Amps: 21,
                breaker3: 22, breaker3Outlet: 23, breaker3Amps: 24,
                breaker4: 25, breaker4Outlet: 26, breaker4Amps: 27,
                breaker5: 28, breaker5Outlet: 29, breaker5Amps: 30
            };

            // Current row data — built when modal opens, reused by loadTemplate
            var _rowData = {};

            function cell(row, idx) {
                var c = row.cells[idx]; return c ? c.innerText.trim() : '';
            }
            function fill(clientId, value) {
                var el = document.getElementById(clientId); if (el) el.value = value;
            }

            // ── Open modal ─────────────────────────────────────────────────
            function showActionsModal(btn) {
                var row = btn.closest('tr');
                var pn = cell(row, COL.partNumber);

                fill('<%= hdnRowIndex.ClientID %>', (row.rowIndex - 1).toString());
                fill('<%= hdnOrigPartNumber.ClientID %>', pn);
                document.getElementById('modalPartLabel').innerText = 'Part: ' + pn;

                // Capture all field values for preview data passing
                _rowData = {
                    partNumber: pn,
                    standard: cell(row, COL.standard),
                    irRating: cell(row, COL.irRating),
                    ratedCurrent: cell(row, COL.ratedCurrent),
                    rmsSym: cell(row, COL.rmsSym),
                    systemVolts: cell(row, COL.systemVolts),
                    frequency: cell(row, COL.frequency),
                    ground: cell(row, COL.ground),
                    neutral: cell(row, COL.neutral),
                    systemConfig: cell(row, COL.systemConfig),
                    phase1: cell(row, COL.phaseConfig1), phase2: cell(row, COL.phaseConfig2),
                    phase3: cell(row, COL.phaseConfig3), phase4: cell(row, COL.phaseConfig4),
                    phase5: cell(row, COL.phaseConfig5),
                    b1: cell(row, COL.breaker1), b1out: cell(row, COL.breaker1Outlet), b1amp: cell(row, COL.breaker1Amps),
                    b2: cell(row, COL.breaker2), b2out: cell(row, COL.breaker2Outlet), b2amp: cell(row, COL.breaker2Amps),
                    b3: cell(row, COL.breaker3), b3out: cell(row, COL.breaker3Outlet), b3amp: cell(row, COL.breaker3Amps),
                    b4: cell(row, COL.breaker4), b4out: cell(row, COL.breaker4Outlet), b4amp: cell(row, COL.breaker4Amps),
                    b5: cell(row, COL.breaker5), b5out: cell(row, COL.breaker5Outlet), b5amp: cell(row, COL.breaker5Amps)
                };

                // Populate edit fields
                fill('<%= editPartNumber.ClientID %>', _rowData.partNumber);
                fill('<%= editStandard.ClientID %>', _rowData.standard);
                fill('<%= editIRRating.ClientID %>', _rowData.irRating);
                fill('<%= editRatedCurrent.ClientID %>', _rowData.ratedCurrent);
                fill('<%= editRMSSym.ClientID %>', _rowData.rmsSym);
                fill('<%= editSystemVolts.ClientID %>', _rowData.systemVolts);
                fill('<%= editFrequency.ClientID %>', _rowData.frequency);
                fill('<%= editGround.ClientID %>', _rowData.ground);
                fill('<%= editNeutral.ClientID %>', _rowData.neutral);
                fill('<%= editSystemConfig.ClientID %>', _rowData.systemConfig);
                fill('<%= editPhaseConfig1.ClientID %>', _rowData.phase1);
                fill('<%= editPhaseConfig2.ClientID %>', _rowData.phase2);
                fill('<%= editPhaseConfig3.ClientID %>', _rowData.phase3);
                fill('<%= editPhaseConfig4.ClientID %>', _rowData.phase4);
                fill('<%= editPhaseConfig5.ClientID %>', _rowData.phase5);
                fill('<%= editBreaker1.ClientID %>',       _rowData.b1);
                fill('<%= editBreaker1Outlet.ClientID %>', _rowData.b1out);
                fill('<%= editBreaker1Amps.ClientID %>',   _rowData.b1amp);
                fill('<%= editBreaker2.ClientID %>',       _rowData.b2);
                fill('<%= editBreaker2Outlet.ClientID %>', _rowData.b2out);
                fill('<%= editBreaker2Amps.ClientID %>',   _rowData.b2amp);
                fill('<%= editBreaker3.ClientID %>',       _rowData.b3);
                fill('<%= editBreaker3Outlet.ClientID %>', _rowData.b3out);
                fill('<%= editBreaker3Amps.ClientID %>',   _rowData.b3amp);
                fill('<%= editBreaker4.ClientID %>',       _rowData.b4);
                fill('<%= editBreaker4Outlet.ClientID %>', _rowData.b4out);
                fill('<%= editBreaker4Amps.ClientID %>',   _rowData.b4amp);
                fill('<%= editBreaker5.ClientID %>',       _rowData.b5);
                fill('<%= editBreaker5Outlet.ClientID %>', _rowData.b5out);
                fill('<%= editBreaker5Amps.ClientID %>',   _rowData.b5amp);

                fill('<%= txtDeletePassword.ClientID %>', '');
                showPanel('tiles');
                document.getElementById('actionsModal').style.display = 'block';
            }

            // ── Close modal ────────────────────────────────────────────────
            function hideActionsModal() {
                document.getElementById('actionsModal').style.display = 'none';
                fill('<%= txtDeletePassword.ClientID %>', '');
                // Reset iframe and preview state
                resetPreviewPanel();
                document.getElementById('modalContent').classList.remove('preview-wide');
            }

            // ── Panel switcher ─────────────────────────────────────────────
            function showPanel(name) {
                ['panelTiles', 'panelEdit', 'panelPreview', 'panelDelete'].forEach(function (id) {
                    document.getElementById(id).style.display = 'none';
                });

                var mc = document.getElementById('modalContent');

                if (name === 'tiles') {
                    document.getElementById('panelTiles').style.display = 'flex';
                    mc.classList.remove('preview-wide');
                }
                if (name === 'edit') { document.getElementById('panelEdit').style.display = 'block'; mc.classList.remove('preview-wide'); }
                if (name === 'delete') { document.getElementById('panelDelete').style.display = 'block'; mc.classList.remove('preview-wide'); }
                if (name === 'preview') {
                    document.getElementById('panelPreview').style.display = 'block';
                    resetPreviewPanel();      // always start on template picker
                }
            }

            // ── Preview: reset to template picker ─────────────────────────
            function resetPreviewPanel() {
                document.getElementById('previewFrameWrap').classList.remove('visible');
                document.getElementById('labelIframe').src = 'about:blank';
                // De-select all tiles
                document.querySelectorAll('.template-tile.active').forEach(function (t) {
                    t.classList.remove('active');
                });
                document.getElementById('modalContent').classList.remove('preview-wide');
            }

            // ── Preview: load a template ───────────────────────────────────
            var TEMPLATE_FILES = {
                'IMPB': 'label-impb.html',
                'MTS': null,   // placeholder
                'HPB': null,   // placeholder
                'GBOX': null    // placeholder
            };

            function loadTemplate(name) {
                var file = TEMPLATE_FILES[name];
                if (!file) return;   // disabled — shouldn't be reachable but guard anyway

                // Mark tile active
                document.querySelectorAll('.template-tile').forEach(function (t) { t.classList.remove('active'); });
                document.getElementById('tile' + name).classList.add('active');

                // Widen modal
                document.getElementById('modalContent').classList.add('preview-wide');

                // Show iframe area
                var wrap = document.getElementById('previewFrameWrap');
                wrap.classList.add('visible');
                document.getElementById('previewFrameLabel').textContent = name + ' Label Preview';

                // Load the label page into the iframe
                var iframe = document.getElementById('labelIframe');

                // Once iframe loads, push data via postMessage
                // When the label page is ready (QRCode lib loaded + signals back),
                // send the data. This replaces the old fixed timeout and fixes
                // the QR code race condition.
                function onLabelReady(evt) {
                    if (evt.data && evt.data.type === 'LABEL_READY') {
                        window.removeEventListener('message', onLabelReady);
                        iframe.contentWindow.postMessage(
                            { type: 'LABEL_DATA', payload: _rowData },
                            '*'
                        );
                    }
                }
                window.addEventListener('message', onLabelReady);

                iframe.src = file;
            }

            // ── Preview: print just the label ─────────────────────────────
            function printLabel() {
                var iframe = document.getElementById('labelIframe');
                if (iframe && iframe.contentWindow) {
                    iframe.contentWindow.focus();
                    iframe.contentWindow.print();
                }
            }

            // Close on backdrop click
            window.onclick = function (e) {
                var modal = document.getElementById('actionsModal');
                if (e.target === modal) hideActionsModal();
            };

        </script>
    </form>
</body>
</html>
