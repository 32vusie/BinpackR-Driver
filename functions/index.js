/* eslint-disable max-len */
/* eslint-disable object-curly-spacing */
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

admin.initializeApp();

// Function to handle notifications for waste collection request updates (Resident-specific)
exports.onRequestUpdate = onDocumentWritten("wasteCollectionRequests/{wasteRequestID}", async (change, context) => {
  const requestId = context.params.wasteRequestID;
  const after = change.after.data();
  const before = change.before ? change.before.data() : null;

  // Send notification only if the status has changed or a driver is assigned/unassigned
  if (!before || after.status !== before.status || after.driverID !== before.driverID) {
    if (!after.userID) {
      logger.info(`No resident associated with waste request ${requestId}, skipping notification.`);
      return;
    }

    // Fetch the resident's FCM token
    const userTokenDoc = await admin.firestore().collection("userTokens").doc(after.userID).get();
    const userToken = userTokenDoc.exists ? userTokenDoc.data().token : null;

    if (!userToken) {
      logger.warn(`No FCM token found for resident ${after.userID}`);
      return;
    }

    // Create the notification payload
    const payload = {
      notification: {
        title: "Waste Collection Update",
        body: `Your waste request ${requestId} status: ${after.status}${after.driverID ? " - Driver assigned" : ""}`,
      },
      data: {
        wasteRequestID: requestId,
      },
    };

    // Send notification to the resident's token
    try {
      await admin.messaging().sendToDevice(userToken, payload);
      logger.info(`Resident notification sent successfully to ${after.userID} for waste request ${requestId}`);
    } catch (error) {
      logger.error(`Error sending resident notification for waste request ${requestId}:`, error);
    }
  }
});

// Function to handle chat message notifications (Resident-specific)
exports.onChatMessage = onDocumentWritten("chatMessages/{messageID}", async (change, context) => {
  const message = change.after.data();
  const recipientID = message.sender === message.userID ? message.driverID : message.userID;

  // Determine if the recipient is a driver or resident and fetch the appropriate token
  const recipientTokenDoc = await admin.firestore()
      .collection(message.sender === message.userID ? "driverTokens" : "userTokens")
      .doc(recipientID)
      .get();
  const recipientToken = recipientTokenDoc.exists ? recipientTokenDoc.data().token : null;

  if (!recipientToken) {
    logger.warn(`No FCM token found for recipient ${recipientID}`);
    return;
  }

  // Create the notification payload
  const payload = {
    notification: {
      title: "New Message",
      body: `You have a new message from ${message.sender === message.userID ? "a driver" : "a resident"}.`,
    },
    data: {
      messageID: context.params.messageID,
    },
  };

  // Send notification to the recipient's token
  try {
    await admin.messaging().sendToDevice(recipientToken, payload);
    logger.info(`Message notification sent successfully to ${recipientID}`);
  } catch (error) {
    logger.error(`Error sending message notification to ${recipientID}:`, error);
  }
});
