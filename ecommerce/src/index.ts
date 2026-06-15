import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

const MSG91_AUTH_KEY = process.env.MSG91_AUTH_TOKEN;
const MSG91_TEMPLATE_ID = process.env.MSG91_WIDGET_ID;

//  Send OTP 
export const sendOtp = onCall(async (request) => {
  const phoneNumber = request.data.phoneNumber;

  if (!phoneNumber) {
    throw new HttpsError("invalid-argument", "Phone number is required.");
  }

  try {
    const response = await axios.get("https://control.msg91.com/api/v5/otp", {
      params: {
        template_id: MSG91_TEMPLATE_ID,
        mobile: phoneNumber,
        authkey: MSG91_AUTH_KEY,
      },
    });

    if (response.data.type === "success") {
      return { success: true, reqId: response.data.request_id };
    } else {
      throw new Error(response.data.message || "Failed to trigger OTP.");
    }
  } catch (error: any) {
    throw new HttpsError("internal", error.message || "Failed to send OTP.");
  }
});

//  Verify OTP & Return Firebase Custom Auth Token
export const verifyOtp = onCall(async (request) => {
  const { reqId, otp, phoneNumber } = request.data;

  if (!reqId || !otp || !phoneNumber) {
    throw new HttpsError("invalid-argument", "Missing parameters: reqId, otp, or phoneNumber.");
  }

  try {
    //Verify OTP with MSG91 API
    const response = await axios.get("https://control.msg91.com/api/v5/otp/verify", {
      params: {
        authkey: MSG91_AUTH_KEY,
        mobile: phoneNumber,
        otp: otp,
        request_id: reqId,
      },
    });

    // Throw error if verification is not successful on MSG91
    if (response.data.type !== "success") {
      throw new HttpsError("permission-denied", response.data.message || "Invalid OTP entered.");
    }

    //  Find or create the user in Firebase Auth
    let userRecord;
    const formattedPhone = `+${phoneNumber}`;

    try {
      userRecord = await admin.auth().getUserByPhoneNumber(formattedPhone);
    } catch (authError: any) {
      if (authError.code === "auth/user-not-found") {
        userRecord = await admin.auth().createUser({
          phoneNumber: formattedPhone,
        });
      } else {
        throw authError;
      }
    }

    //  Generate Firebase Custom Auth JWT Token
    const customToken = await admin.auth().createCustomToken(userRecord.uid);
    return { success: true, customToken: customToken };

  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", error.message || "Verification process failed.");
  }
});
