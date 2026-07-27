function initNavbar() {
    const user = JSON.parse(localStorage.getItem("authUser") || "{}");

    const navUsername = document.getElementById("navUsername");
    const navFullName = document.getElementById("navFullName");
    const navRole = document.getElementById("navRole");

    if (navUsername) navUsername.textContent = user.Username || "";
    if (navFullName) navFullName.textContent = user.FullName || "";
    if (navRole) navRole.textContent = user.Role || "";

    loadNotifications();
}

async function loadNotifications() {
    try {
        const data = await api.get("/reports/inventory");
        const lowStock = data.filter(item => item.StockStatus === "Low Stock");

        const badge = document.getElementById("notifBadge");
        const list = document.getElementById("notifList");
        const empty = document.getElementById("notifEmpty");

        if (lowStock.length > 0) {
            if (badge) {
                badge.textContent = lowStock.length;
                badge.style.display = "inline";
            }
            if (empty) empty.style.display = "none";

            lowStock.forEach(item => {
                const li = document.createElement("li");
                li.className = "px-3 py-2 border-bottom";
                li.innerHTML = `
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                        <div>
                            <div class="small fw-semibold">${item.ProductName}</div>
                            <div class="text-muted" style="font-size:0.75rem;">
                                Stock: ${item.Quantity} | Reorder: ${item.ReorderLevel}
                            </div>
                        </div>
                    </div>
                `;
                if (list) list.appendChild(li);
            });
        } else {
            if (badge) badge.style.display = "none";
            if (empty) empty.style.display = "block";
        }
    } catch (err) {
        console.error("Notification load error:", err);
    }
}

window.showProfile = function() {
    const user = JSON.parse(localStorage.getItem("authUser") || "{}");
    const el = id => document.getElementById(id);

    if (el("profileFullName")) el("profileFullName").textContent = user.FullName || "";
    if (el("profileUsername")) el("profileUsername").textContent = user.Username || "";
    if (el("profileEmail")) el("profileEmail").textContent = user.Email || "Not set";
    if (el("profileRole")) el("profileRole").textContent = user.Role || "";
    if (el("profileRoleDetail")) el("profileRoleDetail").textContent = user.Role || "";

    const modalEl = document.getElementById("profileModal");
    if (modalEl) new bootstrap.Modal(modalEl).show();
};

window.showChangePassword = function() {
    const el = id => document.getElementById(id);
    if (el("currentPassword")) el("currentPassword").value = "";
    if (el("newPassword")) el("newPassword").value = "";
    if (el("confirmPassword")) el("confirmPassword").value = "";
    if (el("passwordError")) el("passwordError").style.display = "none";
    if (el("passwordSuccess")) el("passwordSuccess").style.display = "none";

    const modalEl = document.getElementById("changePasswordModal");
    if (modalEl) new bootstrap.Modal(modalEl).show();
};

window.saveNewPassword = async function() {
    const el = id => document.getElementById(id);
    const current = el("currentPassword").value;
    const newPass = el("newPassword").value;
    const confirm = el("confirmPassword").value;
    const errorBox = el("passwordError");
    const successBox = el("passwordSuccess");

    errorBox.style.display = "none";
    successBox.style.display = "none";

    if (!current || !newPass || !confirm) {
        errorBox.textContent = "All fields are required.";
        errorBox.style.display = "block";
        return;
    }

    if (newPass !== confirm) {
        errorBox.textContent = "New passwords do not match.";
        errorBox.style.display = "block";
        return;
    }

    if (newPass.length < 6) {
        errorBox.textContent = "Password must be at least 6 characters.";
        errorBox.style.display = "block";
        return;
    }

    try {
        await api.post("/auth/change-password", {
            CurrentPassword: current,
            NewPassword: newPass
        });
        successBox.textContent = "Password changed successfully!";
        successBox.style.display = "block";
        setTimeout(() => {
            const modalEl = document.getElementById("changePasswordModal");
            if (modalEl) {
                bootstrap.Modal.getInstance(modalEl).hide();
            }
        }, 1500);
    } catch (err) {
        errorBox.textContent = err.message || "Failed to change password.";
        errorBox.style.display = "block";
    }
};