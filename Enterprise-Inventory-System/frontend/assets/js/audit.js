let auditTableInstance;

async function loadAuditLogs() {
    try {
        if ($.fn.DataTable.isDataTable("#auditTable")) {
            $("#auditTable").DataTable().destroy();
        }

        const data = await api.get("/audit?top=500");

        auditTableInstance = $("#auditTable").DataTable({
            data: data,
            columns: [
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
                        if (data.toLowerCase().includes("login")) color = "success";
                        if (data.toLowerCase().includes("delete") || data.toLowerCase().includes("fail")) color = "danger";
                        if (data.toLowerCase().includes("update") || data.toLowerCase().includes("edit")) color = "warning text-dark";
                        return `<span class="badge bg-${color}">${data}</span>`;
                    }
                },
                { data: "Details", render: data => data || "-" },
                { data: "IPAddress", render: data => data || "-" }
            ],
            responsive: true,
            order: [[0, 'desc']], // Order by LogID descending
            pageLength: 25,
            lengthMenu: [10, 25, 50, 100],
            buttons: getDTExportButtons("Audit Logs", "audit_logs"),
            dom: defaultDTDom,
            language: {
                search: '<i class="bi bi-search"></i>',
                searchPlaceholder: "Search logs..."
            }
        });

    } catch (error) {
        console.error("Error loading audit logs:", error);
    }
}
