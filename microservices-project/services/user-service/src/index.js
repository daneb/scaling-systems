require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const userRoutes = require("./routes/userRoutes");
const healthCheck = require("./middleware/healthCheck");

console.log(healthCheck);

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(healthCheck);

// Routes
app.use("/api/users", userRoutes);

// Health check endpoint
app.get("/health", (req, res) => {
    res.status(200).json({ status: "ok" });
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
