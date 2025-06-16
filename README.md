# azlogistik-backend-technical-test

# README.md

## Setup
1. `psql -f schema.sql`
2. PHP
`GET /report/top-customers.php?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD`

3. Node
- `POST /api/reservation/allocate-table`
- `POST /api/reservation/check`

## Env
`PG_HOST, PG_PORT, PG_DB, PG_USER, PG_PASS` for both stacks.
