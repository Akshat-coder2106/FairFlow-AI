from __future__ import annotations

from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


class FairnessMetrics(BaseModel):
    demographic_parity: float
    equalized_odds: float
    individual_fairness: float
    calibration_error: float
    disparate_impact: float | None = None


class ShapFeatureImpact(BaseModel):
    feature: str
    value: float


class AuditResult(BaseModel):
    audit_id: str | None = None
    user_id: str
    model_name: str
    dataset_name: str
    domain: str = "general"
    model_family: str = "unknown"
    analysis_backend: str = "local"
    bias_score: float
    fairness_metrics: FairnessMetrics
    shap_values: list[dict[str, Any]] = Field(default_factory=list)
    shap_top3: list[str] = Field(default_factory=list)
    causal_graph_json: dict[str, Any] = Field(default_factory=dict)
    demographic_parity: float
    equalized_odds: float
    individual_fairness: float
    calibration_error: float
    gemini_explanation: str = ""
    gemini_recommendations: list[dict[str, Any]] = Field(default_factory=list)
    gemini_legal_risk: str = ""
    gemini_audit_qa: list[dict[str, str]] = Field(default_factory=list)
    candidate_flags: list[dict[str, Any]] = Field(default_factory=list)
    counterfactuals: list[dict[str, Any]] = Field(default_factory=list)
    sdg_tag: str = "SDG 10.3"
    sdg_mapping: list[dict[str, Any]] = Field(default_factory=list)
    status: str = "completed"
    stage: str = "complete"
    vertex_job_name: str | None = None
    created_at: datetime | None = None
