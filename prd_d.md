roject Title: FairShare WG App
Platforms: iOS & Android (Cross-Platform)
Languages: English, German (i18n Support)

1. Executive Summary
Die App dient der transparenten und automatisierten Verwaltung von Wohngemeinschafts-Kosten. Sie berechnet Ausgleichszahlungen zwischen Mitbewohnern, führt eine lückenlose Historie (18 Monate) und automatisiert den monatlichen Abrechnungsprozess durch ein rollenbasiertes Freigabesystem.

2. Tech Stack & Infrastructure

Frontend: Flutter (mit Riverpod für State Management, um die komplexen dynamischen Formulare und Berechnungen performant zu handhaben).

Backend & Auth: Firebase Authentication (Email/Password), Firebase Firestore (für strukturierte Daten wie Rechnungen, Profile, Kosten).

Notifications: Firebase Cloud Messaging (FCM) für automatisierte und manuelle Push-Benachrichtigungen.

Quality & Monitoring: Firebase Crashlytics für Error Tracking in Produktion.

CI/CD: GitLab CI in Kombination mit Fastlane, um automatisierte Builds, Tests und Deployments in den Apple App Store und Google Play Store zu gewährleisten.

3. User Roles

Super Admin: System-Management, Löschen/Bearbeiten aller Nutzer.

Admin: WG-Manager. Erstellt Kosten, prüft monatliche Drafts, publiziert Rechnungen, verwaltet User.

User: WG-Bewohner. Konsumiert Rechnungen, reicht Ansprüche ein, pflegt Profilbild.

4. Key Epics & Features

Epic 1: Authentication & User Management (Login, Profilbild, Namensänderung durch Admin, Rollenvergabe).

Epic 2: Cost Management Engine (CRUD-Operationen für Kosten, Dropdown für Zahlenden, Dynamische Formulare mit Default-Werten, One-Time vs. Recurring).

Epic 3: Billing & Split Algorithm (Berechnung der Schuldenmatrix, 18-Monats-Tabelle, Detail-Ansicht pro Monat).

Epic 4: Workflow & Notifications (Automatischer Trigger am 3. des Monats, Publish-Funktion, Push-Benachrichtigungen).

Epic 5: Dispute Management (Anspruch einreichen, Admin-Alert).