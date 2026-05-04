import {
  type User,
  type InsertUser,
  type Medication,
  type InsertMedication,
  type Appointment,
  type InsertAppointment,
  type CareTeamMember,
  type InsertCareTeamMember,
  type Document,
  type InsertDocument,
  users,
  medications,
  appointments,
  careTeamMembers,
  documents,
} from "@shared/schema";
import { db } from "./db";
import { eq } from "drizzle-orm";

export interface IStorage {
  getUser(id: string): Promise<User | undefined>;
  getUserByUsername(username: string): Promise<User | undefined>;
  createUser(user: InsertUser): Promise<User>;
  deleteUser(id: string): Promise<void>;

  getMedications(): Promise<Medication[]>;
  getMedication(id: number): Promise<Medication | undefined>;
  createMedication(med: InsertMedication): Promise<Medication>;
  updateMedication(id: number, data: Record<string, any>): Promise<Medication | undefined>;
  deleteMedication(id: number): Promise<void>;

  getAppointments(): Promise<Appointment[]>;
  getAppointment(id: number): Promise<Appointment | undefined>;
  createAppointment(appt: InsertAppointment): Promise<Appointment>;
  deleteAppointment(id: number): Promise<void>;

  getCareTeamMembers(): Promise<CareTeamMember[]>;
  createCareTeamMember(member: InsertCareTeamMember): Promise<CareTeamMember>;

  getDocuments(): Promise<Document[]>;
  createDocument(doc: InsertDocument): Promise<Document>;
}

export class DatabaseStorage implements IStorage {
  async getUser(id: string): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.id, id));
    return user;
  }

  async getUserByUsername(username: string): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.username, username));
    return user;
  }

  async createUser(insertUser: InsertUser): Promise<User> {
    const [user] = await db.insert(users).values(insertUser).returning();
    return user;
  }

  async deleteUser(id: string): Promise<void> {
    await db.delete(users).where(eq(users.id, id));
  }

  async getMedications(): Promise<Medication[]> {
    return db.select().from(medications);
  }

  async getMedication(id: number): Promise<Medication | undefined> {
    const [med] = await db.select().from(medications).where(eq(medications.id, id));
    return med;
  }

  async createMedication(med: InsertMedication): Promise<Medication> {
    const [result] = await db.insert(medications).values(med).returning();
    return result;
  }

  async updateMedication(id: number, data: Record<string, any>): Promise<Medication | undefined> {
    const [result] = await db.update(medications).set(data).where(eq(medications.id, id)).returning();
    return result;
  }

  async deleteMedication(id: number): Promise<void> {
    await db.delete(medications).where(eq(medications.id, id));
  }

  async getAppointments(): Promise<Appointment[]> {
    return db.select().from(appointments);
  }

  async getAppointment(id: number): Promise<Appointment | undefined> {
    const [appt] = await db.select().from(appointments).where(eq(appointments.id, id));
    return appt;
  }

  async createAppointment(appt: InsertAppointment): Promise<Appointment> {
    const [result] = await db.insert(appointments).values(appt).returning();
    return result;
  }

  async deleteAppointment(id: number): Promise<void> {
    await db.delete(appointments).where(eq(appointments.id, id));
  }

  async getCareTeamMembers(): Promise<CareTeamMember[]> {
    return db.select().from(careTeamMembers);
  }

  async createCareTeamMember(member: InsertCareTeamMember): Promise<CareTeamMember> {
    const [result] = await db.insert(careTeamMembers).values(member).returning();
    return result;
  }

  async getDocuments(): Promise<Document[]> {
    return db.select().from(documents);
  }

  async createDocument(doc: InsertDocument): Promise<Document> {
    const [result] = await db.insert(documents).values(doc).returning();
    return result;
  }
}

export const storage = new DatabaseStorage();
