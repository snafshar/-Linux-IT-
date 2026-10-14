"""Summarise recorded latency values; does not send network packets."""
from statistics import median


def percentile_summary(samples_ms: list[float]) -> dict[str, float]:
    if not samples_ms:
        raise ValueError("at least one sample is required")
    if any(x < 0 for x in samples_ms):
        raise ValueError("latencies must be non-negative")
    ordered = sorted(samples_ms)

    def nearest_rank(p: float) -> float:
        index = max(0, min(len(ordered) - 1, int((p * len(ordered) + 0.999999)) - 1))
        return ordered[index]

    return {
        "min_ms": ordered[0],
        "median_ms": median(ordered),
        "p95_ms": nearest_rank(0.95),
        "max_ms": ordered[-1],
    }
