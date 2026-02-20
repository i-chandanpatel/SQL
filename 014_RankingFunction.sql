/*==============================================================
RANKING FUNCTIONS (Window Functions)

Ranking functions are used to assign a position or order to rows
within a result set.

There are two main categories:

1️⃣  Integer-Based Ranking (Top/Bottom N Analysis)
    ------------------------------------------------
    • ROW_NUMBER()   → Unique sequential number (no tie handling)
    • RANK()         → Same rank for ties, leaves gaps
    • DENSE_RANK()   → Same rank for ties, no gaps
    • NTILE(n)       → Divides rows into n approximately equal buckets

2️⃣  Percentage-Based Ranking (Distribution Analysis)
    ------------------------------------------------
    • CUME_DIST()    → Cumulative distribution (0–1)
    • PERCENT_RANK() → Relative rank (0–1 scale)

General Syntax:
    <function>() OVER (
        PARTITION BY column   -- optional (group-wise ranking)
        ORDER BY column       -- required (defines ranking order)
    )
==============================================================*/


