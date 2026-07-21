async function handleLogin(event) {
    event.preventDefault();

    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    try {
        const result = await api.post("/auth/login", {
            Username: username,
            Password: password
        });

        localStorage.setItem("authToken", result.token);
        localStorage.setItem("authUser", JSON.stringify(result.user));

        window.location.href = "index.html";

    } catch (err) {
        const errorBox = document.getElementById("loginError");
        errorBox.textContent = err.message || "Login failed";
        errorBox.style.display = "block";
    }
}

function logout() {
    localStorage.removeItem("authToken");
    localStorage.removeItem("authUser");
    window.location.href = "login.html";
}