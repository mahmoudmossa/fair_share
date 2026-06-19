# FairShare App - Development TODO List

## Epic 1: Infrastructure & Base Setup
- ❌ **Initialize Project:** Setup the base Flutter project with Riverpod for state management and configure basic routing.
- ❌ **Firebase Integration:** Connect iOS and Android apps to Firebase (Auth, Firestore, Cloud Messaging, Crashlytics).
- ❌ **CI/CD Pipeline:** Setup GitLab CI/CD and Fastlane for automated builds and deployment to iOS and Android.
- ❌ **Localization:** Implement i18n support for English and German languages.

## Epic 2: Authentication & User Roles
- ❌ **User Authentication System:** Implement Firebase Email/Password login and registration flow for all users.
- ❌ **Role Management Base:** Define data models and Firestore rules for Super Admin, Admin, and normal User roles. Include functionality for Super Admins to delete/edit Admins, and Admins to add/delete normal users.
- ❌ **Profile Management:** Allow users to upload/edit a profile picture. Ensure the display name can ONLY be edited by an Admin or Super Admin.

## Epic 3: Cost Management Engine (Admin Only)
- ❌ **Dynamic Cost Types Form:** Create an admin view to add custom cost types (e.g., Electricity, Internet) using simple string text fields.
- ❌ **Cost Entry & Validation:** Implement required number/price formatting for cost entries. Add a "+" icon to dynamically append multiple costs while editing or creating.
- ❌ **Recurring vs. One-Time Costs:** Add radio buttons to define if a cost is calculated every month or only in specific months. Ensure default values populate correctly when editing an existing cost.
- ❌ **Payer Assignment (Dropdown):** Implement a dropdown in the cost creation form to assign which user actually paid the expense from their bank account.

## Epic 4: Split Algorithm & Calculations
- ❌ **Total Monthly Calculation:** Create the logic to sum up all entered costs of different types for a specific month.
- ❌ **Equal Split Logic:** Implement the algorithm to divide the total monthly costs equally among all participating users in the flat.
- ❌ **Debt Matrix Calculation:** Build the logic to calculate exact debts (who owes whom how much) based on the total flat share vs. what a specific user already paid from their account.
- ❌ **Dynamic Recalculation:** Ensure the debt matrix updates automatically whenever an admin modifies an existing cost, payer, or adds a new cost type.

## Epic 5: Dashboard & Views
- ❌ **User Billing Tab:** Create a dedicated, separate view for users to see the current month's detailed bill, including who paid what, the total split, and current debts.
- ❌ **Audit Trail Display:** Show metadata on the bill indicating which Admin created (`createdBy`), last updated (`updatedBy`), and published the bill.
- ❌ **18-Month History Table:** Implement a tabular view accessible to all users showing the summarized bills (e.g., "February: Electricity 300, Internet 10 = 310") for the last 18 months.

## Epic 6: Workflow, Notifications & Disputes
- ❌ **Automated 3rd-Day Trigger:** Implement logic to trigger an event on the 3rd running day of each month to send a push notification to all Admins to review the new draft and add new costs.
- ❌ **Publish Invoice Feature:** Add a "Publish" button for Admins. When clicked, trigger a push notification via Firebase Cloud Messaging to all normal users that the new bill is ready.
- ❌ **Dispute System (Anspruch):** Allow users to select a specific cost item/type and submit a text message explaining an issue.
- ❌ **Dispute Notifications:** Route submitted disputes automatically as push notifications to the Admins so they can review and adjust the specific cost.