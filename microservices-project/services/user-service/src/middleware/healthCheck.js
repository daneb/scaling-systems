// Simple health check middleware function
const healthcheck = (req, res, next) => {
  // Log that healthcheck middleware is being used
  console.log("Healthcheck middleware initialized successfully");
  
  // You can add additional checks here if needed
  // For example, checking database connection
  
  next();
};

module.exports = healthcheck;
