import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

const MSG91_AUTH_KEY = process.env.MSG91_AUTH_TOKEN;
const MSG91_TEMPLATE_ID = process.env.MSG91_WIDGET_ID;

export const sendOtp = onCall(async (request) => {
  const phoneNumber = request.data.phoneNumber;

  if (!phoneNumber) {
    throw new HttpsError(
      "invalid-argument",
      "Phone number is required",
    );
  }

  try {
    const response = await axios.get(
      "https://control.msg91.com/api/v5/otp",
      {
        params: {
          authkey: MSG91_AUTH_KEY,
          mobile: phoneNumber,
          template_id: MSG91_TEMPLATE_ID,
        },
      },
    );

    if (response.data.type !== "success") {
      throw new Error(
        response.data.message ?? "Failed to send OTP",
      );
    }

    return {
      success: true,
      reqId: response.data.request_id,
      message: response.data.message,
    };
  } catch (e: any) {
    throw new HttpsError(
      "internal",
      e.message ?? "Failed to send OTP",
    );
  }
});

export const verifyOtp = onCall(async (request) => {
  const {reqId, otp, phoneNumber} = request.data;

  if (!reqId || !otp || !phoneNumber) {
    throw new HttpsError(
      "invalid-argument",
      "Missing parameters",
    );
  }

  try {
    const response = await axios.get(
      "https://control.msg91.com/api/v5/otp/verify",
      {
        params: {
          authkey: MSG91_AUTH_KEY,
          mobile: phoneNumber,
          otp,
          request_id: reqId,
        },
      },
    );

    if (response.data.type !== "success") {
      throw new HttpsError(
        "permission-denied",
        response.data.message ??
            "Invalid OTP",
      );
    }

    const formattedPhone = `+${phoneNumber}`;

    let userRecord;

    try {
      userRecord =
          await admin.auth()
              .getUserByPhoneNumber(
                formattedPhone,
              );
    } catch (e: any) {
      if (
        e.code ===
        "auth/user-not-found"
      ) {
        userRecord =
            await admin.auth()
                .createUser({
          phoneNumber:
              formattedPhone,
        });
      } else {
        throw e;
      }
    }

    const customToken =
        await admin.auth()
            .createCustomToken(
              userRecord.uid,
            );

    return {
      success: true,
      customToken,
    };
  } catch (e: any) {
    if (e instanceof HttpsError) {
      throw e;
    }

    throw new HttpsError(
      "internal",
      e.message ??
          "OTP verification failed",
    );
  }
});