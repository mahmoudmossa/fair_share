Project Title: FairShare WG App
Platforms: iOS & Android (Cross-Platform)
Languages: English, German (i18n Support)

1. Executive Summary
The app is designed for the transparent and automated management of shared apartment (WG) expenses. It calculates settlement payments between roommates, maintains a complete history (18 months), and automates the monthly billing process through a role-based approval system.

2. Tech Stack & Infrastructure

Frontend: Flutter (with Riverpod for state management, to efficiently handle the complex dynamic forms and calculations).

Backend & Auth: Firebase Authentication (Email/Password), Firebase Firestore (Multi-tenant structure: global `users` collection -> `wgs` (flats) collection -> `members` subcollection for role mapping, along with invoices, profiles, and costs).

Notifications: Firebase Cloud Messaging (FCM) for automated and manual push notifications.

Quality & Monitoring: Firebase Crashlytics for error tracking in production.

CI/CD: GitLab CI combined with Fastlane to ensure automated builds, tests, and deployments to the Apple App Store and Google Play Store.

3. User Roles

Super Admin: System management, deleting/editing all users and managing all WGs globally.

Admin: WG Manager. Generates 6-digit invitation codes, creates costs, reviews monthly drafts, publishes invoices, and manages members/roles within their specific WG.

User: WG Resident. Joins a WG via an invitation code, views/consumes invoices, submits claims, and maintains profile picture.

4. Key Epics & Features

Epic 1: Authentication & User Management (Firebase Auth Email/Password login, two-step registration with 6-digit WG invitation code, profile picture, name change by WG Admin, role assignment via `members` subcollection in multi-tenant Firestore structure).

Epic 2: Cost Management Engine (CRUD operations for costs, payer dropdown, dynamic forms with default values, one-time vs. recurring costs).

Epic 3: Billing & Split Algorithm (Calculation of the debt matrix, 18-month table, monthly detail view).

Epic 4: Workflow & Notifications (Automatic trigger on the 3rd of each month, publish function, push notifications).

Epic 5: Dispute Management (Submitting claims/disputes, admin alert).