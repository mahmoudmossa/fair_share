// api/cron-calculate-billing.js
// Vercel Serverless Function — Automated Billing Calculation & FCM Push Notification Cron Job

const { initializeApp, cert, getApps } = require('firebase-admin/app');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');
const { GoogleAuth } = require('google-auth-library');

const FCM_ENDPOINT = 'https://fcm.googleapis.com/v1/projects/fairshare-ffea8/messages:send';
const FCM_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';

function initFirebase() {
  if (getApps().length === 0) {
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    initializeApp({
      credential: cert(serviceAccount),
    });
  }
  return getFirestore();
}

async function getFcmAccessToken() {
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  const auth = new GoogleAuth({
    credentials: serviceAccount,
    scopes: [FCM_SCOPE],
  });
  const client = await auth.getClient();
  const tokenResponse = await client.getAccessToken();
  return tokenResponse.token;
}

function getMonthId(date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
}

function getMonthNameFormatted(date) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return `${months[date.getMonth()]} ${date.getFullYear()}`;
}

async function sendFcmNotification(tokens, title, body, data) {
  if (!tokens || tokens.length === 0) return;
  const accessToken = await getFcmAccessToken();

  await Promise.allSettled(
    tokens.map((token) =>
      fetch(FCM_ENDPOINT, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token,
            notification: { title, body },
            android: {
              priority: 'high',
              notification: {
                channel_id: 'fairshare_default',
                sound: 'default',
                default_sound: true,
                default_vibrate_timings: true,
              },
            },
            apns: {
              payload: { aps: { sound: 'default', badge: 1 } },
            },
            ...(data ? { data } : {}),
          },
        }),
      }).then((r) => r.json())
    )
  );
}

module.exports = async function handler(req, res) {
  try {
    // ─── Authentication Check ──────────────────────────────────────────────
    // Accept authentication via x-fairshare-secret, Authorization Bearer token, or Vercel Cron internal header
    const providedSecret = req.headers['x-fairshare-secret'] || req.headers['x-cron-secret'] || (req.headers.authorization ? req.headers.authorization.replace('Bearer ', '') : null);
    const expectedSecret = process.env.FAIRSHARE_API_SECRET;
    const isVercelCron = req.headers['user-agent']?.includes('vercel-cron');

    if (expectedSecret && providedSecret !== expectedSecret && !isVercelCron) {
      return res.status(401).json({ error: 'Unauthorized: Invalid or missing API secret' });
    }

    const db = initFirebase();
    const now = new Date();
    const currentDay = now.getDate();

    // Check query string parameters for force run
    const queryParamForce = req.query?.force || (req.url && req.url.includes('force=true')) || (req.url && req.url.includes('force=1'));
    
    // Check optional env test overrides (e.g. "03:30", "FORCE", or "true")
    const testTargetTime = process.env.CRON_TEST_TARGET_TIME;
    const testTargetDay = process.env.CRON_TEST_TARGET_DAY ? parseInt(process.env.CRON_TEST_TARGET_DAY, 10) : null;

    const currentHourMin = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
    const timeMatched = testTargetTime && (testTargetTime === currentHourMin || testTargetTime === 'FORCE' || testTargetTime === 'true');
    const dayMatched = testTargetDay !== null ? currentDay === testTargetDay : true;

    const forceRun = Boolean(queryParamForce) || Boolean(timeMatched);

    console.log(`Cron triggered at ${now.toISOString()} (Day: ${currentDay}, Time: ${currentHourMin}, ForceRun: ${forceRun})`);

    const wgsSnap = await db.collection('wgs').get();
    let processedCount = 0;

    const flatDiagnostics = [];

    for (const doc of wgsSnap.docs) {
      const flatId = doc.id;
      const flatData = doc.data() || {};
      const billingCalculationDay = flatData.billingCalculationDay || 1;
      const billingCalculationTime = flatData.billingCalculationTime || null;

      // Check if flat dynamic day/time matches current time or override forced
      const matchesFlatDay = currentDay === billingCalculationDay;
      const matchesFlatTime = billingCalculationTime ? currentHourMin === billingCalculationTime : true;

      if (forceRun || (matchesFlatDay && matchesFlatTime && dayMatched)) {
        console.log(`Processing monthly billing calculation for flat: ${flatId}`);

        const currentMonthId = getMonthId(now);
        const nextMonthDate = new Date(now.getFullYear(), now.getMonth() + 1, 1);
        const nextMonthId = getMonthId(nextMonthDate);

        // 1. Fetch expenses (check both subcollection wgs/{flatId}/expenses and top-level expenses filtered by flatId)
        let expensesSnap = await db.collection('wgs').doc(flatId).collection('expenses').get();
        let allExpenses = expensesSnap.docs.map(d => ({ id: d.id, ...d.data() }));

        if (allExpenses.length === 0) {
          const rootExpensesSnap = await db.collection('expenses').where('flatId', '==', flatId).get();
          allExpenses = rootExpensesSnap.docs.map(d => ({ id: d.id, ...d.data() }));
        }

        // 2. Filter ONLY monthly recurring expenses (ignore one_time / Neben non-recurring expenses)
        const monthlyExpenses = allExpenses.filter(e => e.recurrence === 'monthly');

        // Calculate total costs for the current month across all valid items
        const currentMonthTotal = allExpenses.reduce((acc, e) => acc + (Number(e.amount) || 0), 0);
        const recurringTotal = monthlyExpenses.reduce((acc, e) => acc + (Number(e.amount) || 0), 0);

        // 3. Save / Update current month cycle summary into Firestore billing_cycles
        await db.collection('wgs').doc(flatId).collection('billing_cycles').doc(currentMonthId).set({
          monthName: getMonthNameFormatted(now),
          totalCosts: currentMonthTotal,
          settledPercentage: 100.0,
          calculatedAt: Timestamp.fromDate(now),
        }, { merge: true });

        // Update root flat document total costs summary
        await db.collection('wgs').doc(flatId).set({
          lastCalculatedAt: Timestamp.fromDate(now),
          lastCalculatedTotal: currentMonthTotal,
        }, { merge: true });

        // 4. Create new month recurring expense items for next month (ONLY monthly recurring, ignore one_time)
        const nextMonthExpensesSnap = await db.collection('wgs').doc(flatId).collection('expenses').get();
        const nextMonthExpenses = nextMonthExpensesSnap.docs.map(d => d.data());

        const newMonthTimestamp = Timestamp.fromDate(new Date(nextMonthDate.getFullYear(), nextMonthDate.getMonth(), 1, 0, 1));
        for (const exp of monthlyExpenses) {
          // Check if this monthly recurring item already exists in next month
          const existsInNext = nextMonthExpenses.some(e => {
            const expDate = e.timestamp?.toDate ? e.timestamp.toDate() : null;
            return e.title === exp.title && expDate && getMonthId(expDate) === nextMonthId;
          });

          if (!existsInNext) {
            await db.collection('wgs').doc(flatId).collection('expenses').add({
              title: exp.title,
              amount: exp.amount,
              payerId: exp.payerId,
              payerName: exp.payerName,
              recurrence: 'monthly',
              isDisputed: false,
              timestamp: newMonthTimestamp,
            });
          }
        }

        // 5. Save next month billing cycle
        await db.collection('wgs').doc(flatId).collection('billing_cycles').doc(nextMonthId).set({
          monthName: getMonthNameFormatted(nextMonthDate),
          totalCosts: recurringTotal,
          settledPercentage: 0.0,
        }, { merge: true });

        // 6. Collect member FCM tokens (from flat members subcollection or users collection)
        const membersSnap = await db.collection('wgs').doc(flatId).collection('members').get();
        const fcmTokens = [];
        membersSnap.docs.forEach(d => {
          const memberData = d.data();
          if (Array.isArray(memberData.fcmTokens)) {
            fcmTokens.push(...memberData.fcmTokens);
          } else if (memberData.fcmToken) {
            fcmTokens.push(memberData.fcmToken);
          }
        });

        // Fallback: check top-level users collection for flatId
        if (fcmTokens.length === 0) {
          const usersSnap = await db.collection('users').where('flatId', '==', flatId).get();
          usersSnap.docs.forEach(d => {
            const uData = d.data();
            if (Array.isArray(uData.fcmTokens)) {
              fcmTokens.push(...uData.fcmTokens);
            } else if (uData.fcmToken) {
              fcmTokens.push(uData.fcmToken);
            }
          });
        }

        let notificationSent = false;
        if (fcmTokens.length > 0) {
          const title = 'Monthly Expenses Calculated!';
          const body = `Monthly costs for ${getMonthNameFormatted(now)} (${currentMonthTotal} €) have been calculated and updated.`;
          await sendFcmNotification(fcmTokens, title, body, { type: 'costsCalculated', flatId });
          notificationSent = true;
        }

        // 7. Save in-app notification document into each flat member's notifications subcollection: users/{userId}/notifications
        if (membersSnap.docs.length > 0) {
          const notifId = `costsCalculated_${currentMonthId}`;
          for (const memberDoc of membersSnap.docs) {
            const memberId = memberDoc.id;
            await db.collection('users').doc(memberId).collection('notifications').doc(notifId).set({
              id: notifId,
              title: 'Monthly Expenses Calculated!',
              body: `Monthly costs for ${getMonthNameFormatted(now)} (${currentMonthTotal} €) have been calculated and updated.`,
              type: 'costsCalculated',
              isRead: false,
              timestamp: Timestamp.fromDate(now),
              data: { flatId },
            }, { merge: true });
          }
        }

        flatDiagnostics.push({
          flatId,
          expensesCount: allExpenses.length,
          monthlyExpensesCount: monthlyExpenses.length,
          calculatedTotal: currentMonthTotal,
          fcmTokensCount: fcmTokens.length,
          notificationSent,
          billingCycleDoc: currentMonthId,
        });

        processedCount++;
      }
    }

    return res.status(200).json({
      success: true,
      processedFlats: processedCount,
      timestamp: now.toISOString(),
      testTargetTime: testTargetTime || null,
      details: flatDiagnostics,
    });
  } catch (err) {
    console.error('Cron calculation error:', err);
    return res.status(500).json({ error: err.message || 'Internal server error' });
  }
};
