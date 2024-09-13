/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//const {onRequest} = require("firebase-functions/v2/https");
//const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onUserProfileUpdate = functions.database
  .ref('/users/{userId}/{field}')
  .onUpdate(async (change, context) => {
    const userId = context.params.userId;
    const field = context.params.field;
    const newValue = change.after.val();
    const previousValue = change.before.val();

    if (field === 'name' || field === 'email') {
      console.log(`User ${userId} updated ${field} from ${previousValue} to ${newValue}`);

      const userRef = admin.database().ref(`/users/${userId}`);
      const userSnapshot = await userRef.once('value');
      const userData = userSnapshot.val();
      const fcmToken = userData.fcmToken;

      if (fcmToken) {
        const payload = {
          notification: {
            title: 'Profile Updated',
            body: `Your ${field} was updated to ${newValue}.`,
          },
          token: fcmToken
        };
        await admin.messaging().send(payload);
        console.log(`Notification sent to user ${userId}`);
      } else {
        console.log(`No FCM token available for user ${userId}`);
      }
    }
  });

exports.onUserNumberUpdate = functions.database
  .ref('/users/{userId}/{field}')
  .onUpdate(async (change, context) => {
    const userId = context.params.userId;
    const field = context.params.field;
    const newValue = change.after.val();
    const previousValue = change.before.val();

    if (field === 'phone') {
      console.log(`User ${userId} updated ${field} from ${previousValue} to ${newValue}`);

      const userRef = admin.database().ref(`/users/${userId}`);
      const userSnapshot = await userRef.once('value');
      const userData = userSnapshot.val();
      const fcmToken = userData.fcmToken;

      if (fcmToken) {
        const payload = {
          notification: {
            title: 'Profile Updated',
            body: `Your ${field} was updated to ${newValue}.`,
          },
          token: fcmToken
        };
        await admin.messaging().send(payload);
        console.log(`Notification sent to user ${userId}`);
      } else {
        console.log(`No FCM token available for user ${userId}`);
      }
    }
  });



