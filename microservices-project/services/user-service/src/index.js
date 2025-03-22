require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const userRoutes = require("./routes/userRoutes");
const authRoutes = require("./routes/authRoutes");
const healthCheck = require("./middleware/healthCheck");

console.log(healthCheck);

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(healthCheck);

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.originalUrl}`);
  next();
});

// Routes
app.use("/api/users", userRoutes);
app.use("/api/auth", authRoutes);

// API root endpoint
app.get("/api", (req, res) => {
    res.status(200).json({ 
        message: "User Service API",
        endpoints: ["/api/users", "/api/auth", "/health"],
        version: "1.0.0"
    });
});

// Health check endpoint
app.get("/health", (req, res) => {
    console.log("Health check endpoint hit");
    res.status(200).json({ status: "ok" });
});

// Catch-all route for debugging
app.use('*', (req, res) => {
    console.log(`404 - Not Found: ${req.originalUrl}`);
    res.status(404).json({ 
        error: "Not Found", 
        path: req.originalUrl,
        method: req.method,
        timestamp: new Date().toISOString()
    });
});

// Connect to MongoDB
// Connect to MongoDB with more verbose options
mongoose
    .connect(process.env.MONGODB_URI || "mongodb://localhost:27017/users", {
        useNewUrlParser: true,
        useUnifiedTopology: true,
        serverSelectionTimeoutMS: 5000,
        socketTimeoutMS: 45000,
        connectTimeoutMS: 10000,
        heartbeatFrequencyMS: 10000,
    })
    .then(() => console.log("Connected to MongoDB"))
    .catch((err) => {
        console.error("MongoDB connection error details:", {
            message: err.message,
            code: err.code,
            name: err.name,
            stack: err.stack,
        });
        // Optional: Add retry logic
        setTimeout(() => {
            console.log("Retrying connection...");
            process.exit(1); // This will cause the pod to restart and retry
        }, 5000);
    });

// Add some debug logging
mongoose.connection.on("connecting", () => {
    console.log("Connecting to MongoDB...");
});

mongoose.connection.on("connected", () => {
    console.log("Connected to MongoDB!");
});

mongoose.connection.on("error", (err) => {
    console.log("MongoDB connection error:", err);
});

app.listen(PORT, () => {
    console.log(`User service running on port ${PORT}`);
});
