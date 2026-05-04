import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import { insertMedicationSchema, insertAppointmentSchema } from "@shared/schema";
import { seedDatabase } from "./seed";
import {
  createAuthToken,
  hashPassword,
  normalizeEmail,
  publicUser,
  verifyAuthToken,
  verifyPassword,
} from "./auth";
import { z } from "zod";

const registerSchema = z.object({
  name: z.string().trim().min(1, "Name is required").max(80),
  email: z.string().trim().email("Enter a valid email address").max(254),
  password: z.string().min(8, "Password must be at least 8 characters").max(128),
});

const loginSchema = z.object({
  email: z.string().trim().email("Enter a valid email address").max(254),
  password: z.string().min(1, "Password is required").max(128),
});

export async function registerRoutes(
  httpServer: Server,
  app: Express
): Promise<Server> {
  await seedDatabase();

  app.post("/api/auth/register", async (req, res) => {
    const parsed = registerSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({
        message:
          parsed.error.issues[0]?.message ?? "Invalid registration details",
      });
    }

    const email = normalizeEmail(parsed.data.email);
    const displayName = parsed.data.name.trim();
    const existingUser = await storage.getUserByUsername(email);
    if (existingUser) {
      return res
        .status(409)
        .json({ message: "An account with this email already exists" });
    }

    const user = await storage.createUser({
      username: email,
      password: await hashPassword(parsed.data.password),
    });

    res.status(201).json({
      token: createAuthToken(user, displayName),
      user: publicUser(user, displayName),
    });
  });

  app.post("/api/auth/login", async (req, res) => {
    const parsed = loginSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({
        message: parsed.error.issues[0]?.message ?? "Invalid login details",
      });
    }

    const email = normalizeEmail(parsed.data.email);
    const user = await storage.getUserByUsername(email);
    const isValidPassword = user
      ? await verifyPassword(parsed.data.password, user.password)
      : false;

    if (!user || !isValidPassword) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    res.json({
      token: createAuthToken(user),
      user: publicUser(user),
    });
  });

  app.get("/api/auth/me", async (req, res) => {
    const authorization = req.get("authorization");
    const token = authorization?.startsWith("Bearer ")
      ? authorization.substring("Bearer ".length)
      : undefined;

    if (!token) {
      return res.status(401).json({ message: "Authentication required" });
    }

    const payload = verifyAuthToken(token);
    if (!payload) {
      return res.status(401).json({ message: "Invalid or expired session" });
    }

    const user = await storage.getUser(payload.sub);
    if (!user) {
      return res.status(401).json({ message: "Invalid or expired session" });
    }

    res.json({ user: publicUser(user) });
  });

  app.delete("/api/auth/me", async (req, res) => {
    const authorization = req.get("authorization");
    const token = authorization?.startsWith("Bearer ")
      ? authorization.substring("Bearer ".length)
      : undefined;

    if (!token) {
      return res.status(401).json({ message: "Authentication required" });
    }

    const payload = verifyAuthToken(token);
    if (!payload) {
      return res.status(401).json({ message: "Invalid or expired session" });
    }

    const user = await storage.getUser(payload.sub);
    if (!user) {
      return res.status(401).json({ message: "Invalid or expired session" });
    }

    await storage.deleteUser(user.id);
    res.status(204).send();
  });

  app.get("/api/medications", async (_req, res) => {
    const meds = await storage.getMedications();
    res.json(meds);
  });

  app.post("/api/medications", async (req, res) => {
    const parsed = insertMedicationSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ message: parsed.error.message });
    }
    const med = await storage.createMedication(parsed.data);
    res.status(201).json(med);
  });

  app.patch("/api/medications/:id/taken", async (req, res) => {
    const id = parseInt(req.params.id);
    const now = new Date();
    const timeStr = now.toLocaleTimeString("en-US", {
      hour: "numeric",
      minute: "2-digit",
    });
    const updated = await storage.updateMedication(id, {
      lastTaken: `${timeStr} - You`,
    });
    if (!updated) {
      return res.status(404).json({ message: "Medication not found" });
    }
    res.json(updated);
  });

  app.delete("/api/medications/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    await storage.deleteMedication(id);
    res.status(204).send();
  });

  app.get("/api/appointments", async (_req, res) => {
    const appts = await storage.getAppointments();
    res.json(appts);
  });

  app.post("/api/appointments", async (req, res) => {
    const parsed = insertAppointmentSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ message: parsed.error.message });
    }
    const appt = await storage.createAppointment(parsed.data);
    res.status(201).json(appt);
  });

  app.delete("/api/appointments/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    await storage.deleteAppointment(id);
    res.status(204).send();
  });

  app.get("/api/care-team", async (_req, res) => {
    const team = await storage.getCareTeamMembers();
    res.json(team);
  });

  app.get("/api/documents", async (_req, res) => {
    const docs = await storage.getDocuments();
    res.json(docs);
  });

  return httpServer;
}
