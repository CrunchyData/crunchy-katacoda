
LINK TO ADVANCED SCENARIO THAT EXPLAINS XIDS/EXHAUSTION/WRAPAROUND

`autovacuum_freeze_max_age` = 1000000000 (only set this high if monitoring for wraparound. So monitor for wraparound and set it this high.)

`autovacuum_vacuum_threshold` = 500 (default too aggressive)

`autovacuum_analyze_threshold` = 500 (default too aggressive)

`autovacuum_vacuum_scale_factor` = 0.1 (default too mild)

`autovacuum_analyze_scale_factor` = 0.05 (default too mild)

