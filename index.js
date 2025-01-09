import express from "express";
import cors from "cors";
import "dotenv/config";
import apiRouter from "./src/routes/api.js"; // Import apiRouter
import { errorMiddleware } from "./src/middlewares/errorMiddleware.js"; // Import middleware lỗi

const app = express();
const port = process.env.PORT || 3000;

// Lấy __dirname trong ES module

// Middleware
app.use(cors());
app.use(express.json());

// Dịch vụ API
app.use("/api", apiRouter);

// Middleware xử lý lỗi
app.use(errorMiddleware);

// Khởi động server
app.listen(port, "0.0.0.0", () => {
  console.log(`Server đang chạy trên http://localhost:${port}`);
});
