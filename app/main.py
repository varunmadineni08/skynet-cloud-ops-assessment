from fastapi import FastAPI, HTTPException, Query
from datetime import datetime
from typing import Optional
from app.models import Event
from app.storage import store_event, load_events
import os
import time
import logging




app = FastAPI(title="Skynet Ops Audit Service")


SERVICE_NAME = os.getenv("SERVICE_NAME", "skynet-ops-audit-service")
ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@app.get("/health")
def health():
    logger.info("Health check requested")
    return {
        "status": "ok",
        "service": SERVICE_NAME,
        "environment": ENVIRONMENT,
        "timestamp": datetime.utcnow().isoformat()
    }


@app.post("/events", status_code=201)
def create_event(event: Event):

    logger.info(
        f"Audit event received: actor={event.type}, action={event.tenantId}, resource={event.severity}"
    )
    logger.info(
        f"Audit event received: actor={event.type}, action={event.tenantId}, resource={event.severity}"
    )

    store_event(event)

    return {"message": "event stored",
            "event":store_event}

    if not event.tenantId:
        raise HTTPException(status_code=400, detail="tenantId required")

    if not event.message:
        raise HTTPException(status_code=400, detail="message required")

    stored = store_event(event)

    return {
        "success": True,
        "eventId": stored["eventId"],
        "storedAt": stored["storedAt"]
    }


@app.get("/events")
def get_events(
    tenantId: Optional[str] = None,
    severity: Optional[str] = None,
    type: Optional[str] = None,
    limit: int = Query(20, le=100),
    offset: int = 0
):
    logger.info("Events requested")


    events = load_events()
    return events

    if tenantId:
        events = [e for e in events if e["tenantId"] == tenantId]

    if severity:
        events = [e for e in events if e["severity"] == severity]

    if type:
        events = [e for e in events if e["type"] == type]

    events = list(reversed(events))

    total = len(events)

    paginated = events[offset:offset + limit]

    return {
        "items": paginated,
        "total": total,
        "limit": limit,
        "offset": offset
    }




@app.get("/metrics-demo")
def metrics_demo(mode: str = Query(default="normal")):
    
    if mode == "error":
        logger.error("Simulated error triggered")
        raise HTTPException(status_code=500, detail="Simulated server error")

    elif mode == "slow":
        logger.info("Simulating slow request (13 seconds)")
        time.sleep(13)
        return {"status": "slow response simulated"}

    elif mode == "burst":
        logger.info("Simulating log burst")
        for i in range(10):
            logger.info(f"Burst log event {i}")
        return {"status": "burst logs generated"}

    else:
        logger.info("Normal metrics-demo request")
        return {"status": "metrics demo success"}










