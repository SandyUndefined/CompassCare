import { sql } from "drizzle-orm";
import { pgTable, text, varchar, boolean, integer } from "drizzle-orm/pg-core";
import { z } from "zod";

export const users = pgTable("users", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  username: text("username").notNull().unique(),
  password: text("password").notNull(),
});

export const medications = pgTable("medications", {
  id: integer("id").primaryKey().generatedAlwaysAsIdentity(),
  name: text("name").notNull(),
  dosage: text("dosage").notNull(),
  frequency: text("frequency").notNull(),
  time: text("time").notNull(),
  lastTaken: text("last_taken"),
  nextDue: text("next_due"),
  critical: boolean("critical").default(false).notNull(),
});

export const appointments = pgTable("appointments", {
  id: integer("id").primaryKey().generatedAlwaysAsIdentity(),
  type: text("type").notNull(),
  doctor: text("doctor").notNull(),
  date: text("date").notNull(),
  time: text("time").notNull(),
  location: text("location").notNull(),
  assignedTo: text("assigned_to").notNull(),
  notes: text("notes"),
});

export const careTeamMembers = pgTable("care_team_members", {
  id: integer("id").primaryKey().generatedAlwaysAsIdentity(),
  name: text("name").notNull(),
  role: text("role").notNull(),
  online: boolean("online").default(false).notNull(),
  lastActive: text("last_active"),
});

export const documents = pgTable("documents", {
  id: integer("id").primaryKey().generatedAlwaysAsIdentity(),
  name: text("name").notNull(),
  date: text("date").notNull(),
  type: text("type").notNull(),
});

export const insertUserSchema = z.object({
  username: z.string(),
  password: z.string(),
});

export const insertMedicationSchema = z.object({
  name: z.string(),
  dosage: z.string(),
  frequency: z.string(),
  time: z.string(),
  lastTaken: z.string().nullable().optional(),
  nextDue: z.string().nullable().optional(),
  critical: z.boolean().optional().default(false),
});

export const insertAppointmentSchema = z.object({
  type: z.string(),
  doctor: z.string(),
  date: z.string(),
  time: z.string(),
  location: z.string(),
  assignedTo: z.string(),
  notes: z.string().nullable().optional(),
});

export const insertCareTeamMemberSchema = z.object({
  name: z.string(),
  role: z.string(),
  online: z.boolean().optional().default(false),
  lastActive: z.string().nullable().optional(),
});

export const insertDocumentSchema = z.object({
  name: z.string(),
  date: z.string(),
  type: z.string(),
});

export type InsertUser = z.infer<typeof insertUserSchema>;
export type User = typeof users.$inferSelect;
export type Medication = typeof medications.$inferSelect;
export type InsertMedication = z.infer<typeof insertMedicationSchema>;
export type Appointment = typeof appointments.$inferSelect;
export type InsertAppointment = z.infer<typeof insertAppointmentSchema>;
export type CareTeamMember = typeof careTeamMembers.$inferSelect;
export type InsertCareTeamMember = z.infer<typeof insertCareTeamMemberSchema>;
export type Document = typeof documents.$inferSelect;
export type InsertDocument = z.infer<typeof insertDocumentSchema>;
