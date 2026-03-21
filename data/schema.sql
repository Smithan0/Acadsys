CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    school_id TEXT,
    name TEXT,
    class TEXT,
    last_updated TIMESTAMP
);

CREATE TABLE events (
    event_id TEXT PRIMARY KEY,
    operation TEXT,
    entity TEXT,
    record_id INTEGER,
    timestamp TEXT,
    device_id TEXT
);
