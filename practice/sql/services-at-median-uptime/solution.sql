WITH service_avg AS (
    SELECT
        svc_name,
        AVG(uptime) AS avg_uptime
    FROM svc_health
    GROUP BY svc_name
),
ranked_services AS (
    SELECT
        svc_name,
        avg_uptime,
        NTILE(4) OVER (
            ORDER BY avg_uptime ASC
        ) AS uptime_tier,
        MAX(avg_uptime) OVER () AS best_uptime
    FROM service_avg
),
tier_comparison AS (
    SELECT
        svc_name,
        avg_uptime,
        uptime_tier,
        best_uptime,
        MAX(avg_uptime) OVER (
            PARTITION BY uptime_tier
        ) AS tier_best
    FROM ranked_services
)
SELECT
    svc_name,
    ROUND(avg_uptime, 3) AS avg_uptime,
    ROUND(best_uptime - avg_uptime, 3) AS gap_to_best,
    ROUND(tier_best - avg_uptime, 3) AS gap_to_tier_best
FROM tier_comparison
WHERE uptime_tier IN (1, 2)
ORDER BY avg_uptime ASC;
