# Salary Service — Integration Guide

> **Owner:** (your name)  
> **Port:** `8082`  
> **Namespace:** `app`  
> **Internal K8s URL:** `http://salary-service.app.svc.cluster.local:8082`  
> **Salary service Docker Image:** `diwangaamasith/salary-service:latest`
---

## What This Service Does

Handles anonymous salary submissions. No login required to submit.
- Accepts salary data, validates it, and stores as `PENDING`
- Applies anonymization (hides company name when `anonymize=true`)
- Exposes an internal `/approve` endpoint for the **Vote Service** to call
- Does NOT handle auth — that is the BFF's responsibility

---

## Running Locally (for your service development)

Postgres must be running. Use the shared dev compose:

```bash
# From project root
docker compose -f services/docker-compose-dev.yml up -d

# Salary service will be available at:
http://localhost:8082
```

Or connect directly to the K8s deployed one:
```bash
kubectl port-forward -n app svc/salary-service 8082:8082
```

---

## API Endpoints

### 1. Submit a Salary
> No auth required. Anyone can submit.

```
POST /api/v1/salaries
```

**Request Body:**
```json
{
  "jobTitle": "Software Engineer",
  "company": "WSO2",
  "anonymize": true,
  "country": "Sri Lanka",
  "city": "Colombo",
  "experienceYears": 3,
  "level": "MID",
  "grossSalary": 250000.00,
  "currency": "LKR",
  "techStack": ["Java", "Spring Boot", "Kubernetes"]
}
```

**Field Rules:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `jobTitle` | String | ✅ | 2-255 chars |
| `company` | String | ❌ | Hidden if anonymize=true |
| `anonymize` | Boolean | ❌ | Default: true |
| `country` | String | ✅ | Max 100 chars |
| `city` | String | ❌ | Max 100 chars |
| `experienceYears` | Integer | ❌ | 0-50 |
| `level` | String | ❌ | INTERN, JUNIOR, MID, SENIOR, LEAD, PRINCIPAL |
| `grossSalary` | Decimal | ✅ | Greater than 0 |
| `currency` | String | ❌ | Default: LKR |
| `techStack` | String[] | ❌ | Max 20 items |

**Response `201 Created`:**
```json
{
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "jobTitle": "Software Engineer",
    "company": null,
    "country": "Sri Lanka",
    "city": "Colombo",
    "experienceYears": 3,
    "level": "MID",
    "grossSalary": 250000.00,
    "currency": "LKR",
    "techStack": ["Java", "Spring Boot", "Kubernetes"],
    "status": "PENDING",
    "submittedAt": "2026-04-18T20:11:25"
  },
  "message": "Salary submitted. Pending community review.",
  "timestamp": "2026-04-18T20:11:25"
}
```

> Note: `company` is `null` in response when `anonymize=true` — but it IS stored in DB

---

### 2. Get Submission by ID
> No auth required.

```
GET /api/v1/salaries/{id}
```

**Response `200 OK`:** Same structure as submit response.

**Response `404`:**
```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Submission not found: {id}"
  },
  "timestamp": "2026-04-18T20:11:25"
}
```

---

### 3. Approve a Submission ⚠️ INTERNAL ONLY
> **Only the Vote Service should call this.**  
> Not exposed via Ingress. Internal cluster only.

```
PATCH /api/v1/salaries/{id}/approve
Header: X-Internal-Token: {INTERNAL_SERVICE_TOKEN}
```

**Response `200 OK`:**
```json
{
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "status": "APPROVED",
    ...
  },
  "message": "Submission approved"
}
```

**Response `403`:** Wrong or missing internal token  
**Response `404`:** Submission not found or already approved

---

## Submission Status Flow

```
Submit → PENDING → (votes reach threshold) → APPROVED
                 → (reported/rejected)     → REJECTED
```

- **Search Service** should only query `status = 'APPROVED'`
- **Stats Service** should only aggregate `status = 'APPROVED'`
- **Vote Service** calls `/approve` when vote threshold is reached

---

## Standard Response Envelope

ALL responses from this service follow this structure:

```json
{
  "data": { },
  "message": "string or null",
  "error": null,
  "timestamp": "2026-04-18T20:11:25"
}
```

On error:
```json
{
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR | NOT_FOUND | INTERNAL_ERROR",
    "message": "Human readable message",
    "details": {
      "fieldName": "what went wrong"
    }
  },
  "timestamp": "2026-04-18T20:11:25"
}
```

---

## Database

**Schema:** `salary`  
**Table:** `salary.submissions`  
**Important:** No `user_id` or `email` stored — fully anonymous

| Column | Type | Notes |
|---|---|---|
| `id` | UUID | Primary key |
| `job_title` | VARCHAR(255) | |
| `company` | VARCHAR(255) | Stored even if anonymize=true |
| `anonymize` | BOOLEAN | Hide company in public response |
| `country` | VARCHAR(100) | |
| `city` | VARCHAR(100) | |
| `experience_years` | INT | |
| `level` | VARCHAR(50) | |
| `gross_salary` | NUMERIC(14,2) | |
| `currency` | VARCHAR(10) | Default: LKR |
| `tech_stack` | TEXT[] | |
| `status` | VARCHAR(20) | PENDING, APPROVED, REJECTED |
| `submitted_at` | TIMESTAMP | Auto set |
| `approved_at` | TIMESTAMP | Set when approved |

---

## Environment Variables (K8s)

| Variable | Source | Description |
|---|---|---|
| `DB_URL` | ConfigMap `app-config` | JDBC connection string |
| `DB_USER` | ConfigMap `app-config` | DB username |
| `DB_PASSWORD` | Secret `app-secrets` | DB password |
| `INTERNAL_SERVICE_TOKEN` | Secret `app-secrets` | Shared token for /approve |

---

## For BFF Service Owner

Route these paths to salary-service (`http://salary-service.app.svc.cluster.local:8082`):

```
POST  /api/v1/salaries        → forward as-is, no auth needed
GET   /api/v1/salaries/{id}   → forward as-is, no auth needed
```

Do NOT expose `/api/v1/salaries/{id}/approve` through BFF or Ingress.

---

## For Vote Service Owner

When vote threshold is reached, call:

```bash
PATCH http://salary-service.app.svc.cluster.local:8082/api/v1/salaries/{id}/approve
Header: X-Internal-Token: {INTERNAL_SERVICE_TOKEN}
```

Get `INTERNAL_SERVICE_TOKEN` from K8s secret:
```bash
kubectl get secret app-secrets -n app -o jsonpath='{.data.INTERNAL_SERVICE_TOKEN}' | base64 -d
```

---

## For Search Service Owner

Query only APPROVED submissions from DB directly (shared Postgres):

```sql
SELECT * FROM salary.submissions 
WHERE status = 'APPROVED'
AND country = ?
AND job_title ILIKE ?
ORDER BY submitted_at DESC;
```

Schema: `salary`, Table: `submissions`

---

## For Stats Service Owner

Aggregate only APPROVED submissions:

```sql
SELECT 
  job_title,
  country,
  AVG(gross_salary)                                    AS avg_salary,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_salary) AS median_salary,
  COUNT(*)                                             AS total_submissions
FROM salary.submissions
WHERE status = 'APPROVED'
GROUP BY job_title, country;
```

---

## Health Check

```
GET /actuator/health
```

```json
{ "status": "UP" }
```

Used by K8s readiness/liveness probes automatically.

---

## Quick Test Commands

```bash
# Submit
curl -X POST http://techsalary.local/api/v1/salaries \
  -H "Content-Type: application/json" \
  -d '{"jobTitle":"Software Engineer","company":"WSO2","anonymize":true,"country":"Sri Lanka","city":"Colombo","experienceYears":3,"level":"MID","grossSalary":250000,"currency":"LKR","techStack":["Java","Spring Boot"]}'

# Get by ID
curl http://techsalary.local/api/v1/salaries/{id}

# Check DB
kubectl exec -it -n data deployment/postgres -- \
  psql -U techsalary -d techsalary \
  -c "SELECT id, job_title, status, anonymize FROM salary.submissions ORDER BY submitted_at DESC;"
```