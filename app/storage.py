import json
import uuid
from datetime import datetime
from pathlib import Path
import os
DATA_FILE = Path("data/events.json")

def load_events():
    if not DATA_FILE.exists():
        return []
    with open(DATA_FILE) as f:
        return json.load(f)


def save_events(events):
    DATA_FILE.parent.mkdir(exist_ok=True)
    with open(DATA_FILE, "w") as f:
        json.dump(events, f, indent=2)


def store_event(event):
    MAX_EVENTS_LIMIT = int(os.getenv("MAX_EVENTS_LIMIT", 1000))

    events = load_events()

    if len(events) >= MAX_EVENTS_LIMIT:
        events.pop(0)

    event_data = event.dict()
    event_data["eventId"] = f"evt_{uuid.uuid4().hex[:12]}"
    event_data["storedAt"] = datetime.utcnow().isoformat()

    events.append(event_data)

    save_events(events)

    return event_data