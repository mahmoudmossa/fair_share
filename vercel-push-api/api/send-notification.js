// api/send-notification.js
// Vercel Serverless Function — relays FCM push notifications for FairShare
// Deployed free on vercel.com (no credit card required)
//
// Environment variables required (set in Vercel dashboard):
//   FIREBASE_SERVICE_ACCOUNT  — the full JSON string of your service account key
//   FAIRSHARE_API_SECRET      — a random secret your Flutter app sends as a header
//                               to prevent unauthorized calls to this endpoint
//
// How to get the service account key:
//   Firebase Console → Project Settings → Service Accounts → Generate new private key

const { GoogleAuth } = require('google-auth-library');

// ─── Config ───────────────────────────────────────────────────────────────────

const FCM_ENDPOINT = 'https://fcm.googleapis.com/v1/projects/fairshare-ffea8/messages:send';
const FCM_SCOPE    = 'https://www.googleapis.com/auth/firebase.messaging';

// ─── Get a short-lived OAuth2 access token using the service account ──────────

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

// ─── Send one FCM message to a batch of tokens ────────────────────────────────

async function sendFcmMulticast({ tokens, title, body, data }) {
  const accessToken = await getFcmAccessToken();

  // FCM v1 API does not support multicast natively; send one per token.
  // For small flat groups (≤10 members) this is fast enough.
  const results = await Promise.allSettled(
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
            // Forward any extra data fields to the app
            ...(data ? { data } : {}),
          },
        }),
      }).then((r) => r.json())
    )
  );

  // Collect stale tokens (registration-token-not-registered)
  const staleTokens = tokens.filter((_, i) => {
    const result = results[i];
    if (result.status === 'rejected') return false;
    const errorCode = result.value?.error?.details?.[0]?.errorCode;
    return errorCode === 'UNREGISTERED' || errorCode === 'INVALID_ARGUMENT';
  });

  return { results, staleTokens };
}

// ─── Vercel handler ───────────────────────────────────────────────────────────

module.exports = async function handler(req, res) {
  // Only allow POST
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  // Verify the shared secret so only the FairShare app can call this endpoint
  const secret = req.headers['x-fairshare-secret'];
  if (!secret || secret !== process.env.FAIRSHARE_API_SECRET) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const { tokens, title, body, data } = req.body ?? {};

  // Validate payload
  if (!Array.isArray(tokens) || tokens.length === 0) {
    return res.status(400).json({ error: 'tokens must be a non-empty array' });
  }
  if (typeof title !== 'string' || typeof body !== 'string') {
    return res.status(400).json({ error: 'title and body are required strings' });
  }

  try {
    const { results, staleTokens } = await sendFcmMulticast({ tokens, title, body, data });
    return res.status(200).json({
      sent: tokens.length,
      staleTokens,   // Flutter can use this to clean up Firestore
    });
  } catch (err) {
    console.error('FCM send error:', err);
    return res.status(500).json({ error: 'Internal server error' });
  }
};
