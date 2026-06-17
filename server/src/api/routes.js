import express from "express";
import authRoutes from "./auth/routes/auth.routes.js";

export const mainRouter = express.Router();

mainRouter.use("/auth", authRoutes);
