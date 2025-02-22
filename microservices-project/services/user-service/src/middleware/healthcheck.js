const mongoose = require("mongoose");

module.exports = (req, res, next) => {
  if (req.path === "/health") {
    const healthcheck = {
      uptime: process.uptime(),
      message: "OK",
      timestamp: Date.now(),
      mongoStatus:
        mongoose.connection.readyState === 1 ? "connected" : "disconnected",
    };
    res.json(healthcheck);
  } else {
    next();
  }
};
