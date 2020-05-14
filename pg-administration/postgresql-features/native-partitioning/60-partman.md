Automated child table creation for time/id based partitioning is not supported in PostgreSQL, so that must be managed manually. However, there is a third-party tool available that has been around since before native partitioning was introduced called `pg_partman`.

https://github.com/pgpartman/pg_partman

 * Extension to manage pre-native (triggers, constraints, & inheritance) and native partitioning requirements 
 * Pre-creates child partitions to avoid contention
 * Automatically optimized trigger for recent data (non-native)
 * Inherit index/foreign keys from parent (unique index inheritance in native)
 * Partition/unpartition data in manageable commit batches
 * Background worker for maintenance (no cron required)
 * Manage constraints on non-partition columns
 * Naming length limits; ensure complete partition name suffix
 * Ensure consistent child table privileges (mostly non-native, but can apply to native)
 * Supports logical publication & subscription features
 * Sub-partitioning supported
 * Monitoring
    * Check default/parent for unexpected data
    * Check across child tables for uniqueness (not real-time)
    * pg_jobmon - logging & monitoring to ensure maintenance is running properly


