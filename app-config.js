window.APP_CONFIG = {
  API_BASE:
    window.location.protocol === "file:" ||
    window.location.hostname === "" ||
    window.location.hostname === "localhost" ||
    window.location.hostname === "127.0.0.1"
      ? "http://localhost:8080/api/auth"
      : "https://library-management-backend-07hm.onrender.com/api/auth",
};
