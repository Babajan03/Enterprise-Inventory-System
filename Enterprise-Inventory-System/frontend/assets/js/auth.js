async function handleLogin(event) {
    if (event) event.preventDefault();

    const username = document.getElementById("username").value.trim();
    const password = document.getElementById("password").value;
    const errorBox = document.getElementById("loginError");
    const loginBtn = document.getElementById("loginBtn");
    const loginText = document.getElementById("loginText");
    const loginSpinner = document.getElementById("loginSpinner");

    errorBox.style.display = "none";

    if (!username || !password) {
        errorBox.textContent = "Please enter both username and password.";
        errorBox.style.display = "block";
        return;
    }

    // Show spinner
    loginBtn.disabled = true;
    loginText.style.display = "none";
    loginSpinner.style.display = "inline";

    try {
        const result = await api.post("/auth/login", {
            Username: username,
            Password: password
        });

        localStorage.setItem("authToken", result.token);
        localStorage.setItem("authUser", JSON.stringify(result.user));

        window.location.href = "index.html";

    } catch (err) {
        errorBox.textContent = err.message || "Invalid username or password.";
        errorBox.style.display = "block";

        // Reset button
        loginBtn.disabled = false;
        loginText.style.display = "inline";
        loginSpinner.style.display = "none";
    }
}

function logout() {
    localStorage.removeItem("authToken");
    localStorage.removeItem("authUser");
    window.location.href = "login.html";
}