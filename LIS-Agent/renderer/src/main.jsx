import React from "react";
import ReactDOM from "react-dom/client";
import axios from "axios";
import App from "./App";

axios.interceptors.request.use((config) => {
  const token = localStorage.getItem("hims_token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// A 401/403 here means the stored session is missing/expired/invalid
// (HIMS-backend/middleware/auth.js authenticateToken). Previously every page
// just logged "Network Error"/403 to console forever with no way out short
// of manually clearing localStorage — clear the stale session and bounce to
// the login screen instead.
axios.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && (error.response.status === 401 || error.response.status === 403)) {
      localStorage.removeItem("hims_token");
      localStorage.removeItem("branch_id");
      localStorage.removeItem("role");
      localStorage.removeItem("role_level");
      localStorage.removeItem("user");
      localStorage.removeItem("labId");
      window.electronAPI?.saveSetting?.("authToken", null);
      if (window.location.hash !== "#/") {
        window.location.hash = "#/";
      }
    }
    return Promise.reject(error);
  }
);

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);