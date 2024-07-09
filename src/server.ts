import { postgraphile } from "postgraphile";
import express from "express";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

// Middleware to set the API key from the request header
app.use((req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  if (apiKey) {
    res.locals.pgSettings = {
      'app.api_key': apiKey
    };
  }
  next();
});

app.use(
  postgraphile(
    process.env.DATABASE_URL || "postgres://user:password@localhost:5432/dealerships",
    "public",
    {
      watchPg: true,
      graphiql: true,
      enhanceGraphiql: true,
      pgDefaultRole: "anonymous",
      pgSettings: (req) => ({
        'app.api_key': req.headers['x-api-key'] || ''
      }),
      jwtSecret: process.env.JWT_SECRET,
      jwtPgTypeIdentifier: "public.jwt_token",
    }
  )
);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
