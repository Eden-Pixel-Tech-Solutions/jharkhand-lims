import axios from "axios";

import {
  getAbdmHeaders
} from "../utils/abdmHeaders.js";


export const requestEmailVerification =
async (
  accessToken,
  xToken,
  encryptedEmail
) => {

  try {

    const response = await axios.post(

      "https://abhasbx.abdm.gov.in/abha/api/v3/profile/account/request/emailVerificationLink",

      {
        scope: [
          "abha-profile",
          "email-link-verify"
        ],

        loginHint: "email",

        loginId: encryptedEmail,

        otpSystem: "abdm"
      },

      {
        headers: {

          ...getAbdmHeaders(
            accessToken
          ),

          "X-Token":
            `Bearer ${xToken}`
        }
      }
    );

    return response.data;

  } catch (error) {

    console.error(
      "Email Verification Error:",
      error.response?.data ||
      error.message
    );

    throw error;
  }
};