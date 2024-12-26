const OneSignal = require('onesignal-node');
const dotenv = require('dotenv');

dotenv.config();

const client = new OneSignal.Client(
  process.env.APP_ID,
  process.env.REST_API_KEY
); 

// Hàm gửi thông báo
async function sendNotificationToAllDevices({
  title,
  content,
  icon,
  imageUrl,
}) {
  try {
    const notification = {
      headings: {
        en: title,
      },
      contents: {
        en: content,
      },
      included_segments: ["All"],
      large_icon: icon,
    };

    if (imageUrl) {
      notification.big_picture = imageUrl;
    }

    const response = await client.createNotification(notification);
    console.log("Notification sent:", response);
  } catch (error) {
    console.error(
      "Error sending notification:",
      error.response?.data || error.message
    );
  }
}

async function sendNotificationToSpecificDevice(playerId, message) {
  try {
    const notification = {
      contents: {
        en: message,
      },
      include_player_ids: [playerId],
    };

    const response = await client.createNotification(notification);
    console.log("Notification sent to device:", response);
  } catch (error) {
    console.error(
      "Error sending notification to device:",
      error.response?.data || error.message
    );
  }
}

module.exports = {
  sendNotificationToAllDevices,
  sendNotificationToSpecificDevice,
};