import axios from "axios";
import crypto from "crypto";
import moment from "moment";
import { getAbdmHeaders } from "../utils/abdmHeaders.js";

export const requestAadhaarOtp = async (
  accessToken,
  encryptedAadhaar
) => {

  try {

    const response = await axios.post(
      "https://abhasbx.abdm.gov.in/abha/api/v3/enrollment/request/otp",

      {
        txnId: "",

        scope: [
          "abha-enrol"
        ],

        loginHint: "aadhaar",

        loginId: encryptedAadhaar,

        otpSystem: "aadhaar"
      },

      {
        headers: {

          Authorization:
            `Bearer ${accessToken}`,

          "Content-Type":
            "application/json",

          "REQUEST-ID":
            crypto.randomUUID(),

          "TIMESTAMP":
            moment()
              .utc()
              .format(
                "YYYY-MM-DDTHH:mm:ss.SSS[Z]"
              ),

          "X-CM-ID":
            "sbx"
        }
      }
    );

    return response.data;

  } catch (error) {

    console.error(
      "Aadhaar OTP Error:",
      error.response?.data ||
      error.message
    );

    throw error;
  }
};