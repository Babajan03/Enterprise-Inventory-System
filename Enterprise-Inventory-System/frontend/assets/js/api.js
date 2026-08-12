const API_BASE = "http://127.0.0.1:5000";

async function apiRequest(endpoint, options = {}) {
    const token = localStorage.getItem("authToken");

    const headers = {
        "Content-Type": "application/json",
        "Cache-Control": "no-cache, no-store, must-revalidate",
        "Pragma": "no-cache",
        ...(token ? { "Authorization": `Bearer ${token}` } : {}),
        ...options.headers
    };

    // Append timestamp to GET requests to force fresh data from backend SQL DB
    let url = API_BASE + endpoint;
    if ((!options.method || options.method === "GET")) {
        const separator = url.includes("?") ? "&" : "?";
        url += `${separator}_t=${Date.now()}`;
    }

    const response = await fetch(url, {
        cache: "no-store",
        ...options,
        headers
    });

    let data;
    try {
        data = await response.json();
    } catch {
        data = null;
    }

    if (!response.ok) {
        if (response.status === 401) {
            localStorage.removeItem("authToken");
            localStorage.removeItem("user");
            window.location.href = "login.html";
            return null;
        }
        const message = (data && data.message) || `Request failed: ${response.status}`;
        throw new Error(message);
    }

    return data;
}

const api = {
    get: (endpoint) =>
        apiRequest(endpoint, { method: "GET" }),

    post: (endpoint, body) =>
        apiRequest(endpoint, { method: "POST", body: JSON.stringify(body) }),

    put: (endpoint, body) =>
        apiRequest(endpoint, { method: "PUT", body: JSON.stringify(body) }),

    delete: (endpoint) =>
        apiRequest(endpoint, { method: "DELETE" })
};