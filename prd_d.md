roject Title: FairShare WG App
Platforms: iOS & Android (Cross-Platform)
Languages: English, German (i18n Support)

1. Executive Summary
Die App dient der transparenten und automatisierten Verwaltung von Wohngemeinschafts-Kosten. Sie berechnet Ausgleichszahlungen zwischen Mitbewohnern, führt eine lückenlose Historie (18 Monate) und automatisiert den monatlichen Abrechnungsprozess durch ein rollenbasiertes Freigabesystem.

2. Tech Stack & Infrastructure

Frontend: Flutter (mit Riverpod für State Management, um die komplexen dynamischen Formulare und Berechnungen performant zu handhaben).

Backend & Auth: Firebase Authentication (Email/Password), Firebase Firestore (Multi-Tenant-Struktur: globale `users`-Sammlung -> `wgs` (Wohngemeinschaften)-Sammlung -> `members`-Untersammlung für Rollenzuordnung, sowie Rechnungen, Profile und Kosten).

Notifications: Firebase Cloud Messaging (FCM) für automatisierte und manuelle Push-Benachrichtigungen.

Quality & Monitoring: Firebase Crashlytics für Error Tracking in Produktion.

CI/CD: GitLab CI in Kombination mit Fastlane, um automatisierte Builds, Tests und Deployments in den Apple App Store und Google Play Store zu gewährleisten.

3. User Roles

Super Admin: System-Management, Löschen/Bearbeiten aller Nutzer und WGs global.

Admin: WG-Manager. Generiert 6-stellige Einladungscodes, erstellt Kosten, prüft monatliche Drafts, publiziert Rechnungen, verwaltet Mitglieder/Rollen innerhalb der WG.

User: WG-Bewohner. Tritt einer WG über einen Einladungscode bei, konsumiert Rechnungen, reicht Ansprüche ein, pflegt Profilbild.

4. Key Epics & Features

Epic 1: Authentication & User Management (Registrierung über E-Mail/Passwort mit anschließendem Beitritt über 6-stelligen WG-Einladungscode, Profilbild, Namensänderung durch WG-Admin, Rollenvergabe über die `members`-Untersammlung in einer Multi-Tenant-Struktur).

Epic 2: Cost Management Engine (CRUD-Operationen für Kosten, Dropdown für Zahlenden, Dynamische Formulare mit Default-Werten, One-Time vs. Recurring).

Epic 3: Billing & Split Algorithm (Berechnung der Schuldenmatrix, 18-Monats-Tabelle, Detail-Ansicht pro Monat).

Epic 4: Workflow & Notifications (Automatischer Trigger am 3. des Monats, Publish-Funktion, Push-Benachrichtigungen).

Epic 5: Dispute Management (Anspruch einreichen, Admin-Alert).