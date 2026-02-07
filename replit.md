# CompassCare - Family Caregiving Coordination App

## Overview
CompassCare helps families coordinate care for their loved ones. It tracks medications, appointments, medical documents, and keeps the care team connected.

## Tech Stack
- **Frontend**: React + TypeScript, Vite, TanStack Query, shadcn/ui, Tailwind CSS, wouter
- **Backend**: Express.js + TypeScript
- **Database**: PostgreSQL with Drizzle ORM
- **Package Manager**: npm

## Project Structure
```
client/src/
  pages/home.tsx          - Main page with tabbed interface
  components/
    compass-logo.tsx      - SVG compass logo component
    theme-toggle.tsx      - Light/dark mode toggle
    medications-tab.tsx   - Medication tracking & management
    appointments-tab.tsx  - Appointment scheduling
    documents-tab.tsx     - Medical document listing
    care-team-tab.tsx     - Care team member display
    shopping-tab.tsx      - Care supply shopping links
    ui/                   - Shadcn components
server/
  index.ts               - Express server entry
  routes.ts              - API route definitions
  storage.ts             - Database storage layer
  db.ts                  - Database connection
  seed.ts                - Seed data for initial load
shared/
  schema.ts              - Drizzle schema & types
```

## Database Schema
- `medications` - name, dosage, frequency, time, lastTaken, nextDue, critical
- `appointments` - type, doctor, date, time, location, assignedTo, notes
- `care_team_members` - name, role, online, lastActive
- `documents` - name, date, type

## API Endpoints
- `GET /api/medications` - List all medications
- `POST /api/medications` - Add medication
- `PATCH /api/medications/:id/taken` - Mark medication as taken
- `DELETE /api/medications/:id` - Remove medication
- `GET /api/appointments` - List appointments
- `POST /api/appointments` - Add appointment
- `DELETE /api/appointments/:id` - Remove appointment
- `GET /api/care-team` - List care team members
- `GET /api/documents` - List documents

## Running
- `npm run dev` starts both frontend and backend on port 5000
- `npx drizzle-kit push` to push schema changes

## Design
- Uses Inter font family
- Indigo-based primary color palette (243 75% 59%)
- Full dark mode support via class toggle
- Responsive layout with mobile-friendly tab navigation
