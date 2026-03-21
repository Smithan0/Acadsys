Acadsys Architecture

Offline-First Multi-School Management System

---

1. System Design Goals

- Operate fully without internet (offline-first)
- Support multiple schools (multi-tenant architecture)
- Ensure data consistency across devices
- Handle unreliable and intermittent connectivity
- Maintain simple, modular, and extensible structure

---

2. Core Design Principles

2.1 Offline-First

All critical operations must work locally without requiring network access.

2.2 Local Source of Truth (Temporary)

Each client maintains its own local database. The system reconciles differences during synchronization.

2.3 Eventual Consistency

Instead of strict real-time consistency, the system ensures that all nodes converge to the same state over time.

2.4 Multi-Tenant Isolation

Each school’s data is logically isolated to prevent cross-access and ensure scalability.

---

3. High-Level Architecture

Components:

1. Client Application
2. Local Database (SQLite)
3. Sync Engine
4. Backend API
5. Central Database

---

4. Data Flow

4.1 Offline Operation

- User performs action (e.g., add student)
- Data is written to local database
- Change is logged in a local "event log"

4.2 Sync Trigger

Sync is triggered when:

- Internet becomes available
- Manual user action
- Scheduled background task

4.3 Synchronization Flow

Push Phase:

- Client sends local changes (events) to backend
- Backend validates and stores changes

Pull Phase:

- Client requests updates from backend
- Backend returns changes from other devices

---

5. Data Model Strategy

5.1 Multi-Tenant Design

Each record includes:

- "school_id"
- "record_id"
- "last_updated"
- "device_id"

This ensures:

- Logical separation between schools
- Safe synchronization across devices

---

5.2 Event-Based Synchronization (Preferred)

Instead of syncing full tables, the system tracks:

- CREATE
- UPDATE
- DELETE

Each change is stored as an event:

Example:

{
  "event_id": "uuid",
  "type": "UPDATE",
  "entity": "student",
  "record_id": 101,
  "timestamp": "2026-03-22T10:00:00",
  "device_id": "device_1"
}

---

6. Conflict Resolution Strategy

Conflicts occur when:

- Same record is modified on multiple devices before sync

Initial Strategy (Simple and Practical):

Last Write Wins (LWW)

- The most recent update overrides older ones

Future Upgrade:

- Field-level merge
- User-assisted conflict resolution

---

7. Sync Engine Responsibilities

- Track local changes (event log)
- Package and send updates to backend
- Receive updates from backend
- Apply updates to local database
- Resolve conflicts

---

8. Backend Responsibilities

- Store global state
- Maintain event logs
- Authenticate requests (future)
- Serve updates to clients
- Ensure tenant isolation (school-level separation)

---

9. Failure Handling

Network Failure:

- Operations continue locally
- Sync retries later

Partial Sync Failure:

- Retry failed operations
- Maintain idempotency (avoid duplicates)

---

10. Scalability Considerations

Current Target:

- 1–5 schools
- Low to moderate data volume

Future Scaling:

- Partition data by school_id
- Optimize sync batching
- Introduce message queues (advanced stage)

---

11. Security Considerations (Early Stage)

- Basic data separation via school_id
- Future:
  - Authentication (user roles)
  - Data encryption
  - Secure sync endpoints

---

12. Trade-Offs

Decision| Benefit| Cost
Offline-first| Works without internet| Complex sync logic
Event-based sync| Efficient updates| Requires event tracking
Last Write Wins| Simple conflict handling| Possible data overwrite
SQLite local DB| Lightweight| Limited scalability per device

---

13. Future Improvements

- CRDT-based conflict resolution (advanced)
- Real-time sync when online
- Role-based access control
- Analytics and reporting layer
- Mobile-first UI

---

14. Summary

Acadsys is designed as a resilient, offline-capable system that prioritizes usability in constrained environments while maintaining a path toward scalable, multi-tenant architecture.

The current focus is correctness of system design rather than feature completeness.
