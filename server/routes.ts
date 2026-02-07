import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import { insertMedicationSchema, insertAppointmentSchema } from "@shared/schema";
import { seedDatabase } from "./seed";

export async function registerRoutes(
  httpServer: Server,
  app: Express
): Promise<Server> {
  await seedDatabase();

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
    const timeStr = now.toLocaleTimeString("en-US", { hour: "numeric", minute: "2-digit" });
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
