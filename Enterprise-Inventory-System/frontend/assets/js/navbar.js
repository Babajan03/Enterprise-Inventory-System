function initNavbar() {
    const user = JSON.parse(localStorage.getItem("authUser") || "{}");

    // Set username in navbar
    const navUsername = document.getElementById("navUsername");
    const navFullName = document.getElementById("navFullName");
    const navRole = document.getElementById("navRole");

    if (navUsername) navUsername.textContent = user.Username || "";
    if (navFullName) navFullName.textContent = user.FullName || "";
    if (navRole) navRole.textContent = user.Role || "";

    // Load notifications (low stock alerts)
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
            badge.textContent = lowStock.length;
            badge.style.display = "inline";
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
                list.appendChild(li);
            });
        } else {
            badge.style.display = "none";
        }
    } catch (err) {
        console.error("Notification load error:", err);
    }
}

window.showProfile = function() {
    const user = JSON.parse(localStorage.getItem("authUser") || "{}");
    document.getElementById("profileFullName").textContent = user.FullName || "";
    document.getElementById("profileUsername").textContent = user.Username || "";
    document.getElementById("profileEmail").textContent = user.Email || "Not set";
    document.getElementById("profileRole").textContent = user.Role || "";
    document.getElementById("profileRoleDetail").textContent = user.Role || "";
    new bootstrap.Modal(document.getElementById("profileModal")).show();
};

window.showChangePassword = function() {
    document.getElementById("currentPassword").value = "";
    document.getElementById("newPassword").value = "";
    document.getElementById("confirmPassword").value = "";
    document.getElementById("passwordError").style.display = "none";
    document.getElementById("passwordSuccess").style.display = "none";
    new bootstrap.Modal(document.getElementById("changePasswordModal")).show();
};

window.saveNewPassword = async function() {
    const current = document.getElementById("currentPassword").value;
    const newPass = document.getElementById("newPassword").value;
    const confirm = document.getElementById("confirmPassword").value;
    const errorBox = document.getElementById("passwordError");
    const successBox = document.getElementById("passwordSuccess");

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
            bootstrap.Modal.getInstance(
                document.getElementById("changePasswordModal")
            ).hide();
        }, 1500);
    } catch (err) {
        errorBox.textContent = err.message || "Failed to change password.";
        errorBox.style.display = "block";
    }
};