import axios from "axios";
import moment from "moment";

import { getAbdmHeaders }
from "../utils/abdmHeaders.js";


// ========================================
// SEND MOBILE OTP
// ========================================

export const sendMobileOtp =
async (
  accessToken,
  txnId,
  encryptedMobile
) => {

  try {

    const response = await axios.post(

      "https://abhasbx.abdm.gov.in/abha/api/v3/enrollment/request/otp",

      {
        txnId,

        scope: [
          "abha-enrol",
          "mobile-verify"
        ],

        loginHint: "mobile",

        loginId:
          encryptedMobile,

        otpSystem: "abdm"
      },

      {
        headers:
          getAbdmHeaders(accessToken)
      }
    );

    return response.data;

  } catch (error) {

    console.error(
      "Mobile OTP Error:",
      error.response?.data ||
      error.message
    );

    throw error;
  }
};


// ========================================
// VERIFY MOBILE OTP
// ========================================

export const verifyMobileOtp = async (
  accessToken,
  txnId,
  encryptedOtp
) => {

  try {

    const response = await axios.post(

      "https://abhasbx.abdm.gov.in/abha/api/v3/enrollment/auth/byAbdm",

      {
        scope: [
          "abha-enrol",
          "mobile-verify"
        ],

        authData: {

          authMethods: [
            "otp"
          ],

          otp: {

            // IMPORTANT:
            // Must NOT use ISO string
            // Must follow ABDM format
            timeStamp:
              moment().format(
                "YYYY-MM-DD HH:mm:ss"
              ),

            txnId,

            // OTP MUST remain encrypted
            otpValue: encryptedOtp
          }
        }
      },

      {
        headers:
          getAbdmHeaders(accessToken)
      }
    );

    return response.data;

  } catch (error) {

    console.error(
      "Verify Mobile OTP Error:",
      error.response?.data ||
      error.message
    );

    throw error;
  }
};