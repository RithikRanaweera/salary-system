#!/bin/bash

# ─────────────────────────────────────────────
# TechSalary LK — Full API Test Script
# ─────────────────────────────────────────────

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

pass() { echo -e "${GREEN}✅ $1${NC}"; }
fail() { echo -e "${RED}❌ $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
section() { echo -e "\n${YELLOW}═══ $1 ═══${NC}"; }

# ── Ports ─────────────────────────────────────
BFF="http://localhost:3000"
IDENTITY="http://localhost:7081"
SALARY="http://localhost:7082"
VOTE="http://localhost:7083"
SEARCH="http://localhost:7084"
STATS="http://localhost:7085"

TOKEN=""
SUBMISSION_ID=""

# ─────────────────────────────────────────────
section "1. HEALTH CHECKS"
# ─────────────────────────────────────────────

for svc in "$BFF/health" "$IDENTITY/auth/health" "$SALARY/actuator/health" "$VOTE/votes/health" "$SEARCH/health" "$STATS/health"; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$svc")
  if [ "$STATUS" = "200" ]; then
    pass "$svc → $STATUS"
  else
    fail "$svc → $STATUS"
  fi
done

# ─────────────────────────────────────────────
section "2. IDENTITY — Direct (port 7081)"
# ─────────────────────────────────────────────

info "Signup..."
SIGNUP=$(curl -s -X POST "$IDENTITY/auth/signup" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@techsalary.lk","password":"Test@1234"}')
echo "$SIGNUP" | python3 -m json.tool 2>/dev/null || echo "$SIGNUP"

info "Login..."
LOGIN=$(curl -s -X POST "$IDENTITY/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@techsalary.lk","password":"Test@1234"}')
echo "$LOGIN" | python3 -m json.tool 2>/dev/null || echo "$LOGIN"

TOKEN=$(echo "$LOGIN" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('token',''))" 2>/dev/null)
if [ -n "$TOKEN" ]; then
  pass "JWT token received"
  info "Token: ${TOKEN:0:50}..."
else
  fail "No token received — check identity-service response"
fi

info "Validate token..."
VALIDATE=$(curl -s "$IDENTITY/auth/validate" \
  -H "Authorization: Bearer $TOKEN")
echo "$VALIDATE" | python3 -m json.tool 2>/dev/null || echo "$VALIDATE"

# ─────────────────────────────────────────────
section "3. IDENTITY — Via BFF (port 3000)"
# ─────────────────────────────────────────────

info "Signup via BFF..."
BFF_SIGNUP=$(curl -s -X POST "$BFF/api/signup" \
  -H "Content-Type: application/json" \
  -d '{"email":"bffuser@techsalary.lk","password":"Test@1234"}')
echo "$BFF_SIGNUP" | python3 -m json.tool 2>/dev/null || echo "$BFF_SIGNUP"

info "Login via BFF..."
BFF_LOGIN=$(curl -s -X POST "$BFF/api/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@techsalary.lk","password":"Test@1234"}')
echo "$BFF_LOGIN" | python3 -m json.tool 2>/dev/null || echo "$BFF_LOGIN"

# ─────────────────────────────────────────────
section "4. SALARY — Direct (port 7082)"
# ─────────────────────────────────────────────

info "Submit salary (no auth needed)..."
SUBMIT=$(curl -s -X POST "$SALARY/v1/salaries" \
  -H "Content-Type: application/json" \
  -d '{
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
  }')
echo "$SUBMIT" | python3 -m json.tool 2>/dev/null || echo "$SUBMIT"

SUBMISSION_ID=$(echo "$SUBMIT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('id',''))" 2>/dev/null)
if [ -n "$SUBMISSION_ID" ]; then
  pass "Submission created: $SUBMISSION_ID"
else
  fail "No submission ID — check salary-service response"
fi

info "Get submission by ID..."
GET_SUB=$(curl -s "$SALARY/v1/salaries/$SUBMISSION_ID")
echo "$GET_SUB" | python3 -m json.tool 2>/dev/null || echo "$GET_SUB"

# ─────────────────────────────────────────────
section "5. SALARY — Via BFF (port 3000)"
# ─────────────────────────────────────────────

info "Submit salary via BFF..."
BFF_SUBMIT=$(curl -s -X POST "$BFF/api/salary/submit" \
  -H "Content-Type: application/json" \
  -d '{
    "jobTitle": "DevOps Engineer",
    "company": "Sysco Labs",
    "anonymize": false,
    "country": "Sri Lanka",
    "city": "Colombo",
    "experienceYears": 5,
    "level": "SENIOR",
    "grossSalary": 380000.00,
    "currency": "LKR",
    "techStack": ["Kubernetes", "Terraform", "AWS"]
  }')
echo "$BFF_SUBMIT" | python3 -m json.tool 2>/dev/null || echo "$BFF_SUBMIT"

BFF_SUBMISSION_ID=$(echo "$BFF_SUBMIT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('id',''))" 2>/dev/null)

# ── Use BFF submission ID if direct submit failed ──────────
if [ -z "$SUBMISSION_ID" ] && [ -n "$BFF_SUBMISSION_ID" ]; then
  SUBMISSION_ID=$BFF_SUBMISSION_ID
  info "Using BFF submission ID for voting: $SUBMISSION_ID"
fi

# ─────────────────────────────────────────────
section "6. VOTE — Direct (port 7083)"
# ─────────────────────────────────────────────

if [ -z "$TOKEN" ]; then
  fail "No token — skipping vote tests"
else
  info "Cast upvote on submission (auth required)..."
  VOTE_RESP=$(curl -s -X POST "$VOTE/votes" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "{\"submissionId\": \"$SUBMISSION_ID\", \"upvote\": true}")
  echo "$VOTE_RESP" | python3 -m json.tool 2>/dev/null || echo "$VOTE_RESP"

  info "Get upvote count..."
  COUNT=$(curl -s "$VOTE/votes/$SUBMISSION_ID/count")
  echo "$COUNT" | python3 -m json.tool 2>/dev/null || echo "$COUNT"

  info "Try voting without token (should return 401)..."
  NO_AUTH=$(curl -s -X POST "$VOTE/votes" \
    -H "Content-Type: application/json" \
    -d "{\"submissionId\": \"$SUBMISSION_ID\", \"upvote\": true}")
  echo "$NO_AUTH" | python3 -m json.tool 2>/dev/null || echo "$NO_AUTH"
fi

# ─────────────────────────────────────────────
section "7. CHECK SUBMISSION STATUS AFTER VOTE"
# ─────────────────────────────────────────────

info "Submission should be APPROVED (threshold=1)..."
AFTER_VOTE=$(curl -s "$SALARY/v1/salaries/$SUBMISSION_ID")
echo "$AFTER_VOTE" | python3 -m json.tool 2>/dev/null || echo "$AFTER_VOTE"

STATUS=$(echo "$AFTER_VOTE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('status',''))" 2>/dev/null)
if [ "$STATUS" = "APPROVED" ]; then
  pass "Submission is APPROVED ✅"
else
  fail "Submission status is '$STATUS' — expected APPROVED"
fi

# ─────────────────────────────────────────────
section "8. SEARCH — Direct (port 7084)"
# ─────────────────────────────────────────────

info "Search all..."
SEARCH_ALL=$(curl -s "$SEARCH/search")
echo "$SEARCH_ALL" | python3 -m json.tool 2>/dev/null || echo "$SEARCH_ALL"

info "Search by country..."
SEARCH_COUNTRY=$(curl -s "$SEARCH/search?country=Sri+Lanka")
echo "$SEARCH_COUNTRY" | python3 -m json.tool 2>/dev/null || echo "$SEARCH_COUNTRY"

info "Search by role..."
SEARCH_ROLE=$(curl -s "$SEARCH/search?role=Software+Engineer")
echo "$SEARCH_ROLE" | python3 -m json.tool 2>/dev/null || echo "$SEARCH_ROLE"

info "Search by level..."
SEARCH_LEVEL=$(curl -s "$SEARCH/search?level=MID")
echo "$SEARCH_LEVEL" | python3 -m json.tool 2>/dev/null || echo "$SEARCH_LEVEL"

info "Get available filters..."
FILTERS=$(curl -s "$SEARCH/search/filters")
echo "$FILTERS" | python3 -m json.tool 2>/dev/null || echo "$FILTERS"

# ─────────────────────────────────────────────
section "9. STATS — Direct (port 7085)"
# ─────────────────────────────────────────────

info "Get salary stats..."
STATS_RESP=$(curl -s "$STATS/stats")
echo "$STATS_RESP" | python3 -m json.tool 2>/dev/null || echo "$STATS_RESP"

info "Get top companies..."
TOP_CO=$(curl -s "$STATS/stats/top-companies")
echo "$TOP_CO" | python3 -m json.tool 2>/dev/null || echo "$TOP_CO"

# ─────────────────────────────────────────────
section "10. VALIDATION TESTS"
# ─────────────────────────────────────────────

info "Submit with missing required fields (should return 400)..."
BAD_SUBMIT=$(curl -s -X POST "$SALARY/v1/salaries" \
  -H "Content-Type: application/json" \
  -d '{"jobTitle": ""}')
echo "$BAD_SUBMIT" | python3 -m json.tool 2>/dev/null || echo "$BAD_SUBMIT"

info "Login with wrong password (should return 401/403)..."
BAD_LOGIN=$(curl -s -X POST "$IDENTITY/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@techsalary.lk","password":"wrongpass"}')
echo "$BAD_LOGIN" | python3 -m json.tool 2>/dev/null || echo "$BAD_LOGIN"

info "Vote without auth (should return 401)..."
NO_AUTH_VOTE=$(curl -s -X POST "$VOTE/votes" \
  -H "Content-Type: application/json" \
  -d "{\"submissionId\": \"$SUBMISSION_ID\", \"upvote\": true}")
echo "$NO_AUTH_VOTE" | python3 -m json.tool 2>/dev/null || echo "$NO_AUTH_VOTE"

# ─────────────────────────────────────────────
section "SUMMARY"
# ─────────────────────────────────────────────
echo ""
info "Full workflow tested:"
echo "  Register → Login → Submit → Vote → APPROVED → Search → Stats"
echo ""
info "Submission ID used: $SUBMISSION_ID"
info "Token used: ${TOKEN:0:30}..."
echo ""
