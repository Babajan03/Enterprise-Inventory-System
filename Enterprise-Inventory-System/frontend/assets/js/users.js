let usersTableInstance = null;
let usersData = [];

async function loadUsers() {
    try {
        usersData = await api.get("/users");
        updateUserStats(usersData);
        renderUsersTable(usersData);
    } catch (err) {
        showToast("Error loading users: " + err.message, "danger");
    }
}

function updateUserStats(users) {
    const total = users.length;
    const active = users.filter(u => u.IsActive).length;
    const admins = users.filter(u => (u.Role || "").toLowerCase() === "admin").length;
    const staff = total - admins;

    if (document.getElementById("userStatTotal")) document.getElementById("userStatTotal").textContent = total;
    if (document.getElementById("userStatActive")) document.getElementById("userStatActive").textContent = active;
    if (document.getElementById("userStatAdmin")) document.getElementById("userStatAdmin").textContent = admins;
    if (document.getElementById("userStatStaff")) document.getElementById("userStatStaff").textContent = staff;
}

function renderUsersTable(users) {
    const columns = [
        { data: "UserID", title: "ID", width: "50px" },
        {
            data: "FullName",
            title: "User",
            render: (data, type, row) => `
                <div class="d-flex align-items-center">
                    <div class="rounded-circle bg-secondary bg-opacity-10 text-primary fw-bold d-flex align-items-center justify-content-center me-2" style="width:36px; height:36px; font-size:14px;">
                        ${(data || row.Username || "U").substring(0, 2).toUpperCase()}
                    </div>
                    <div>
                        <div class="fw-bold text-dark">${data || row.Username}</div>
                        <small class="text-muted">@${row.Username}</small>
                    </div>
                </div>
            `
        },
        {
            data: "Email",
            title: "Email",
            render: v => v ? `<i class="bi bi-envelope text-muted me-1"></i>${v}` : `<span class="text-muted small">—</span>`
        },
        {
            data: "Role",
            title: "Role",
            render: role => {
                const r = (role || "Staff").toLowerCase();
                let badgeClass = "bg-secondary";
                let icon = "bi-person";
                if (r === "admin") { badgeClass = "bg-danger"; icon = "bi-shield-lock-fill"; }
                else if (r === "manager") { badgeClass = "bg-primary"; icon = "bi-briefcase-fill"; }
                else if (r === "staff") { badgeClass = "bg-info text-dark"; icon = "bi-person-badge"; }
                return `<span class="badge ${badgeClass} px-2 py-1"><i class="bi ${icon} me-1"></i>${role}</span>`;
            }
        },
        {
            data: "IsActive",
            title: "Status",
            render: (isActive, type, row) => `
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" ${isActive ? "checked" : ""} 
                        onchange="window.toggleUserStatus(${row.UserID}, ${isActive})" title="Toggle Active Status">
                    <span class="badge ${isActive ? "bg-success" : "bg-secondary"} ms-1">
                        ${isActive ? "Active" : "Inactive"}
                    </span>
                </div>
            `
        },
        {
            data: "CreatedDate",
            title: "Created Date",
            render: v => v ? new Date(v).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" }) : "-"
        },
        {
            data: null,
            title: "Actions",
            className: "text-end",
            orderable: false,
            render: (data, type, row) => `
                <button class="btn btn-sm btn-outline-primary me-1" onclick="window.openEditUserModal(${row.UserID})" title="Edit User">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-warning" onclick="window.openResetPasswordModal(${row.UserID}, '${row.Username}')" title="Reset Password">
                    <i class="bi bi-key"></i>
                </button>
            `
        }
    ];

    usersTableInstance = updateOrInitDataTable("#usersTable", usersTableInstance, users, columns, {
        buttons: getDTExportButtons("Users Directory", "users")
    });
}

window.openAddUserModal = function() {
    document.getElementById("userForm").reset();
    document.getElementById("userId").value = "";
    document.getElementById("userModalTitle").textContent = "Add New User";
    document.getElementById("userUsername").readOnly = false;
    document.getElementById("passwordGroup").style.display = "block";
    document.getElementById("userPassword").required = true;
    document.getElementById("statusSwitchGroup").style.display = "none";

    const modal = new bootstrap.Modal(document.getElementById("userModal"));
    modal.show();
};

window.openEditUserModal = function(userId) {
    const user = usersData.find(u => u.UserID === userId);
    if (!user) return;

    document.getElementById("userForm").reset();
    document.getElementById("userId").value = user.UserID;
    document.getElementById("userModalTitle").textContent = "Edit User: " + user.Username;
    document.getElementById("userUsername").value = user.Username;
    document.getElementById("userUsername").readOnly = true;
    document.getElementById("passwordGroup").style.display = "none";
    document.getElementById("userPassword").required = false;
    document.getElementById("userFullName").value = user.FullName || "";
    document.getElementById("userEmail").value = user.Email || "";
    document.getElementById("userRole").value = user.Role || "Staff";
    document.getElementById("userIsActive").checked = !!user.IsActive;
    document.getElementById("statusSwitchGroup").style.display = "block";

    const modal = new bootstrap.Modal(document.getElementById("userModal"));
    modal.show();
};

window.saveUser = async function(event) {
    if (event) event.preventDefault();
    const userId = document.getElementById("userId").value;
    const isEdit = !!userId;

    const payload = {
        Username: document.getElementById("userUsername").value.trim(),
        FullName: document.getElementById("userFullName").value.trim(),
        Email: document.getElementById("userEmail").value.trim(),
        Role: document.getElementById("userRole").value,
        IsActive: document.getElementById("userIsActive").checked
    };

    if (!isEdit) {
        payload.Password = document.getElementById("userPassword").value;
    }

    try {
        if (isEdit) {
            await api.put(`/users/${userId}`, payload);
            showToast("User updated successfully!", "success");
        } else {
            await api.post("/users", payload);
            showToast("User created successfully!", "success");
        }

        const modalEl = document.getElementById("userModal");
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();

        await loadUsers();
    } catch (err) {
        showToast("Error saving user: " + err.message, "danger");
    }
};

window.toggleUserStatus = async function(userId, currentStatus) {
    try {
        await api.put(`/users/${userId}/status`, { IsActive: !currentStatus });
        showToast("User status updated!", "success");
        await loadUsers();
    } catch (err) {
        showToast("Error updating user status: " + err.message, "danger");
        await loadUsers();
    }
};

window.openResetPasswordModal = function(userId, username) {
    document.getElementById("resetPasswordForm").reset();
    document.getElementById("resetUserId").value = userId;
    document.getElementById("resetTargetUsername").textContent = "@" + username;

    const modal = new bootstrap.Modal(document.getElementById("resetPasswordModal"));
    modal.show();
};

window.submitResetPassword = async function(event) {
    if (event) event.preventDefault();
    const userId = document.getElementById("resetUserId").value;
    const newPassword = document.getElementById("resetNewPassword").value;

    try {
        await api.put(`/users/${userId}/reset-password`, { NewPassword: newPassword });

        const modalEl = document.getElementById("resetPasswordModal");
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();

        showToast("Password reset successfully!", "success");
    } catch (err) {
        showToast("Error resetting password: " + err.message, "danger");
    }
};

// Toast notification helper
function showToast(message, type = "success") {
    const existing = document.getElementById("appToast");
    if (existing) existing.remove();
    const toast = document.createElement("div");
    toast.id = "appToast";
    toast.className = `alert alert-${type} position-fixed shadow-lg`;
    toast.style.cssText = "top:20px;right:20px;z-index:9999;min-width:300px;animation:slideIn 0.3s ease;";
    toast.innerHTML = `
        <div class="d-flex align-items-center gap-2">
            <i class="bi ${type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill'}"></i>
            <span>${message}</span>
            <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.remove()"></button>
        </div>
    `;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 4000);
}
