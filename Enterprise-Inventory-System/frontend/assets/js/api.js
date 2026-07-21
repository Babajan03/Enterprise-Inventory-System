const API_BASE = "http://127.0.0.1:5000";

async function apiRequest(endpoint, options = {}) {
    const token = localStorage.getItem("authToken");

    const headers = {
        "Content-Type": "application/json",
        ...(token ? { "Authorization": `Bearer ${token}` } : {}),
        ...options.headers
    };

    const response = await fetch(API_BASE + endpoint, {
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