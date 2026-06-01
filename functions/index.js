// FCCU Societies Hub – Cloud Functions
// Deploy: cd functions && npm install && cd .. && firebase deploy --only functions
//
// These functions listen for new notification documents written by the client
// (likePost / createComment batch writes) and fan them out as FCM push messages
// to the recipient's device.

const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

const db = getFirestore();
const messaging = getMessaging();

// ---------------------------------------------------------------------------
// sendPushOnNotification
//
// Triggers whenever a new item is written to
//   notifications/{userId}/items/{notifId}
// Looks up the recipient's stored FCM token and sends a push.
// ---------------------------------------------------------------------------
exports.sendPushOnNotification = onDocumentCreated(
  "notifications/{userId}/items/{notifId}",
  async (event) => {
    const { userId } = event.params;
    const notif = event.data?.data();
    if (!notif) return;

    // Look up the recipient's FCM token
    const userSnap = await db.collection("users").doc(userId).get();
    const token = userSnap.data()?.fcmToken;
    if (!token) return; // user hasn't opened the app yet / no token

    const isLike = notif.type === "like";
    const title = isLike
      ? `${notif.actorName} liked your post`
      : `${notif.actorName} commented on your post`;

    const body = isLike
      ? notif.postContent || ""
      : notif.commentContent || notif.postContent || "";

    try {
      await messaging.send({
        token,
        notification: { title, body },
        android: {
          notification: {
            channelId: "fccu_societies_hub",
            priority: "high",
          },
        },
        apns: {
          payload: {
            aps: { sound: "default", badge: 1 },
          },
        },
        // Pass postId so the app can open the right screen on tap
        data: { postId: notif.postId ?? "" },
      });
    } catch (err) {
      // Token may be stale — clean it up so we don't retry
      if (
        err.code === "messaging/registration-token-not-registered" ||
        err.code === "messaging/invalid-registration-token"
      ) {
        await db.collection("users").doc(userId).update({ fcmToken: null });
      }
      console.error("FCM send error:", err.code, err.message);
    }
  }
);
