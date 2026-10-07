# Security Policy

Thanks for helping keep Sedra Wallet and its users safe.

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security problems.** Use one of these private channels:

1. **GitHub Security Advisory (preferred)**
   Open a private vulnerability report via the
   [“Report a vulnerability”](https://github.com/karyalangitdigital/sedracoin-wallet/security/advisories/new) form on the Security tab.
2. **Email fallback**
   Send a report to **karyalangitdigital@gmail.com** with the subject line
   `Sedra Wallet Security Report`.

Please include:

- A concise description of the issue and its security impact.
- The affected version / tag / commit SHA.
- Step-by-step instructions to reproduce on a stock device.
- A proof of concept or minimal exploit code when possible.
- Any relevant log excerpts (with **all** seed material and private keys redacted).

## Our Commitment

We aim to:

1. **Acknowledge** receipt within **72 hours**.
2. **Triage** the report and communicate severity within **7 days**.
3. **Ship a fix** (or a coordinated disclosure plan) as soon as practical, prioritized by user impact.
4. **Publish** a GitHub Security Advisory with a CVE when applicable, and **credit you** in the release notes if you'd like to be named.

## Scope

**In scope:**

- Wallet key handling, BIP39/BIP44 derivation, secure storage, and signing paths
  (`lib/sedra/wallet_service/`, `lib/wallet_signer/`, `lib/encrypt/`, `lib/wallet_auth/`).
- Transaction construction, UTXO selection, and the RPC layer including the
  gRPC ↔ REST circuit breaker (`lib/sedra/rpc/`, `lib/sedra/api/`).
- Push-notification claim flow and identity service (`lib/push/`).
- Platform integration and permissions (`android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`).

**Out of scope:**

- Bugs in the upstream Sedra full node (`sedrad`) or third-party endpoints
  (`api.sedracoin.com`, `explorer.sedracoin.com`, `push.sedracoin.com`) — report to the operator.
- Physical device compromise, social engineering, or lost seed phrases.
- Issues that require the user to install untrusted apps or hand over their device.

## Supported Versions

| Version         | Supported |
| :-------------- | :-------- |
| Latest release  | ✅ Yes    |
| Previous minor  | ⚠️ Best-effort |
| Anything older  | ❌ Please upgrade before reporting |

## Responsible Disclosure

We ask that you:

- Give us a reasonable window (**90 days** is customary) to fix before public disclosure.
- Not post exploits, PoC code, or affected addresses publicly before a fix ships.
- Not access or modify other users' data as part of your testing.

Thank you for helping keep Sedra users safe.
