from __future__ import annotations

from typing import Any


SDG_TARGETS: tuple[dict[str, Any], ...] = (
    {
        "target": "SDG 10.3",
        "title": "Equal opportunity and reduced inequalities of outcome",
        "legal_threshold": "Four-fifths rule and parity gap review",
        "metric_keys": ("demographic_parity", "disparate_impact"),
        "thresholds": {
            "demographic_parity": {"operator": "<=", "value": 0.10},
            "disparate_impact": {"operator": ">=", "value": 0.80},
        },
    },
    {
        "target": "SDG 8.5",
        "title": "Full, productive employment and equal pay for equal work",
        "legal_threshold": "Employment selection parity review",
        "metric_keys": ("demographic_parity", "equalized_odds"),
        "thresholds": {
            "demographic_parity": {"operator": "<=", "value": 0.10},
            "equalized_odds": {"operator": "<=", "value": 0.10},
        },
    },
    {
        "target": "SDG 16.b",
        "title": "Non-discriminatory laws and policies",
        "legal_threshold": "Adverse impact and procedural fairness review",
        "metric_keys": ("equalized_odds", "calibration_error"),
        "thresholds": {
            "equalized_odds": {"operator": "<=", "value": 0.10},
            "calibration_error": {"operator": "<=", "value": 0.10},
        },
    },
)


def _metric_value(metrics: dict[str, Any], key: str) -> float:
    try:
        return abs(float(metrics.get(key, 0)))
    except Exception:
        return 0.0


def _passes_threshold(value: float, threshold: dict[str, Any]) -> bool:
    operator = threshold.get("operator")
    limit = float(threshold.get("value", 0))
    if operator == ">=":
        return value >= limit
    if operator == "<=":
        return value <= limit
    return False


def build_sdg_mapping(metrics: dict[str, Any], domain: str) -> list[dict[str, Any]]:
    mapping: list[dict[str, Any]] = []
    for target in SDG_TARGETS:
        metric_rows = []
        target_passes = True
        for key in target["metric_keys"]:
            threshold = target["thresholds"][key]
            raw_value = metrics.get(key, 0)
            comparable_value = _metric_value(metrics, key)
            if key == "disparate_impact":
                comparable_value = float(raw_value or 0)
            passes = _passes_threshold(comparable_value, threshold)
            target_passes = target_passes and passes
            metric_rows.append(
                {
                    "metric": key,
                    "value": raw_value,
                    "threshold": threshold,
                    "passes": passes,
                }
            )

        mapping.append(
            {
                "target": target["target"],
                "title": target["title"],
                "domain": domain,
                "legal_threshold": target["legal_threshold"],
                "metrics": metric_rows,
                "status": "aligned" if target_passes else "needs_review",
            }
        )
    return mapping
