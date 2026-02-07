import { db } from "./db";
import { medications, appointments, careTeamMembers, documents } from "@shared/schema";
import { sql } from "drizzle-orm";

export async function seedDatabase() {
  const [existingMeds] = await db.select({ count: sql<number>`count(*)` }).from(medications);
  if (Number(existingMeds.count) > 0) return;

  await db.insert(medications).values([
    {
      name: "Lisinopril",
      dosage: "10mg",
      frequency: "Once daily",
      time: "8:00 AM",
      lastTaken: "8:05 AM - Sarah",
      nextDue: "8:00 AM tomorrow",
      critical: true,
    },
    {
      name: "Metformin",
      dosage: "500mg",
      frequency: "Twice daily",
      time: "8:00 AM, 8:00 PM",
      lastTaken: "8:10 AM - Michael",
      nextDue: "8:00 PM today",
      critical: false,
    },
    {
      name: "Aspirin",
      dosage: "81mg",
      frequency: "Once daily",
      time: "9:00 AM",
      lastTaken: "9:02 AM - Linda",
      nextDue: "9:00 AM tomorrow",
      critical: false,
    },
  ]);

  await db.insert(appointments).values([
    {
      type: "Cardiology",
      doctor: "Dr. Johnson",
      date: "Feb 10, 2026",
      time: "2:30 PM",
      location: "Memorial Hospital",
      assignedTo: "Sarah",
      notes: "Bring recent blood pressure log",
    },
    {
      type: "Primary Care",
      doctor: "Dr. Smith",
      date: "Feb 15, 2026",
      time: "10:00 AM",
      location: "Family Health Center",
      assignedTo: "Michael",
      notes: "Annual checkup",
    },
    {
      type: "Ophthalmology",
      doctor: "Dr. Lee",
      date: "Feb 22, 2026",
      time: "1:00 PM",
      location: "Vision Care Clinic",
      assignedTo: "Linda",
      notes: "Diabetic eye exam - dilating drops will be used",
    },
  ]);

  await db.insert(careTeamMembers).values([
    { name: "Sarah", role: "Daughter", online: true, lastActive: "Just now" },
    { name: "Michael", role: "Son", online: true, lastActive: "5 min ago" },
    { name: "Linda", role: "Spouse", online: false, lastActive: "2 hours ago" },
  ]);

  await db.insert(documents).values([
    { name: "Insurance Card", date: "Updated Jan 15, 2026", type: "PDF" },
    { name: "Blood Pressure Log", date: "Updated Feb 5, 2026", type: "PDF" },
    { name: "Lab Results - Dec 2025", date: "Dec 20, 2025", type: "PDF" },
    { name: "Medication List", date: "Updated Feb 1, 2026", type: "PDF" },
    { name: "Advance Directive", date: "Mar 10, 2025", type: "PDF" },
  ]);

  console.log("Database seeded successfully");
}
