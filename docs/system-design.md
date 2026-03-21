System Design – Sync Lifecycle

1. Local Write Operation

- User adds or updates data (e.g., student record)
- Data is written to local database (SQLite)
- Change is recorded in event log

2. Event Log Entry

Each change generates an event:

- event_id
- operation (CREATE / UPDATE / DELETE)
- timestamp
- device_id

3. Sync Trigger

Triggered by:

- internet availability
- manual sync
- background process

4. Push Phase

- Local events are sent to backend
- Backend validates and stores events

5. Pull Phase

- Client requests updates from backend
- Receives events from other devices

6. Conflict Handling

Initial approach:

- Last Write Wins (based on timestamp)

Future improvements:

- field-level merging
- conflict resolution UI

7. Data Consistency Model

- Eventual consistency
- All nodes converge over time

8. Failure Handling

- Failed sync retries automatically
- Local system remains functional offline
