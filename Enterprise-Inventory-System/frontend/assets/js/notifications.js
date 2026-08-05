// Notifications logic
async function fetchNotifications() {
    try {
        const notifs = await api.get("/notifications?unread=true");
        const notifBadge = document.getElementById("notifBadge");
        const notifList = document.getElementById("notifList");
        const notifEmpty = document.getElementById("notifEmpty");
        
        // Remove existing items
        document.querySelectorAll(".notif-item").forEach(e => e.remove());

        if (notifs.length > 0) {
            notifBadge.style.display = "block";
            notifBadge.textContent = notifs.length;
            if(notifEmpty) notifEmpty.style.display = "none";
            
            notifs.forEach(n => {
                const li = document.createElement("li");
                li.className = "dropdown-item px-3 py-2 border-bottom notif-item text-wrap";
                li.style.cursor = "pointer";
                li.innerHTML = `
                    <div class="d-flex justify-content-between">
                        <small class="text-primary"><i class="bi bi-info-circle me-1"></i> Alert</small>
                        <small class="text-muted" style="font-size:0.7rem;">${new Date(n.CreatedDate).toLocaleTimeString()}</small>
                    </div>
                    <div class="mt-1" style="font-size:0.85rem;">${n.Message}</div>
                `;
                li.onclick = async (e) => {
                    e.stopPropagation();
                    await api.post(`/notifications/${n.NotificationID}/read`, {});
                    fetchNotifications();
                };
                notifList.appendChild(li);
            });
        } else {
            notifBadge.style.display = "none";
            if(notifEmpty) notifEmpty.style.display = "block";
        }
    } catch (error) {
        console.error("Error fetching notifications:", error);
    }
}

// Poll every 30 seconds
setInterval(fetchNotifications, 30000);

// Fetch on load
document.addEventListener("DOMContentLoaded", () => {
    // wait a moment for token to be available
    setTimeout(fetchNotifications, 1000);
});
