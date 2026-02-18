# Security notes (booking app)

## Data sensitivity
- Treat PII (email, phone), auth tokens, and payment-related data as sensitive.
- Never log secrets or tokens.

## Storage
- Don’t store auth tokens in insecure storage.
- If using secure storage, document the package + threat model in an ADR.

## Network
- Use TLS only.
- Validate server responses; handle timeouts and retries intentionally.

## Abuse cases
- Rate-limit / lockout logic belongs server-side, but client should:
  - avoid leaking whether an account exists,
  - use generic error messages for auth/lookup failures.

## Supply chain
- Prefer well-maintained packages.
- Record new dependencies in ADRs if they are security-relevant (auth, crypto, payments).
