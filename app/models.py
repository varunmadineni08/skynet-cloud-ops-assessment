from pydantic import BaseModel
from typing import Optional, Dict
from datetime import datetime
from enum import Enum


class Severity(str, Enum):
    info = "info"
    warning = "warning"
    error = "error"
    critical = "critical"


class Event(BaseModel):
    type: str
    tenantId: str
    severity: Severity
    message: str
    source: str
    metadata: Optional[Dict] = None
    occurredAt: Optional[datetime] = None
    traceId: Optional[str] = None