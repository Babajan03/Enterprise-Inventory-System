let auditTableInstance = null;

async function loadAuditLogs() {
    try {
        const data = await api.get("/audit?top=500");
        const columns = [
            { data: "LogID", width: "80px" },
            { 
                data: "LogDate", 
                render: function(data) {
                    if (!data) return "-";
                    const d = new Date(data);
                    return d.toLocaleString("en-IN", {
                        day: "2-digit", month: "short", year: "numeric",
                        hour: "2-digit", minute: "2-digit", second: "2-digit"
                    });
                }
            },
            { 
                data: "Username",
                render: function(data) {
                    return data ? `<span class="badge bg-secondary"><i class="bi bi-person me-1"></i>${data}</span>` : `<span class="text-muted">System</span>`;
                }
            },
            { 
                data: "Action",
                render: function(data) {
                    let color = "primary";
                    const lower = (data || "").toLowerCase();
                    if (lower.includes("login")) color = "success";
                    if (lower.includes("delete") || lower.includes("fail")) color = "danger";
                    if (lower.includes("update") || lower.includes("edit")) color = "warning text-dark";
                    return `<span class="badge bg-${color}">${data}</span>`;
                }
            },
            { data: "Details", render: data => data || "-" },
            { data: "IPAddress", render: data => data || "-" }
        ];

        auditTableInstance = updateOrInitDataTable("#auditTable", auditTableInstance, data, columns, {
            buttons: getDTExportButtons("Audit Logs", "audit_logs"),
            pageLength: 25,
            lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
        });

    } catch (error) {
        console.error("Error loading audit logs:", error);
    }
}
