//abdmAuthService.js
import axios from "axios";
import crypto from "crypto";
import moment from "moment";

export const generateAccessToken = async () => {

  try {

    const response = await axios.post(
      "https://dev.abdm.gov.in/api/hiecm/gateway/v3/sessions",

      {
        clientId: process.env.ABDM_CLIENT_ID,
        clientSecret: process.env.ABDM_CLIENT_SECRET,
        grantType: "client_credentials"
      },

      {
        headers: {
          "Content-Type": "application/json",

          // REQUIRED ABDM HEADERS
          "REQUEST-ID": crypto.randomUUID(),

          "TIMESTAMP": moment().utc().format("YYYY-MM-DDTHH:mm:ss.SSS[Z]"),

          "X-CM-ID": "sbx"
        }
      }
    );

    return response.data;

  } catch (error) {

    console.error(
      "ABDM Token Error:",
      error.response?.data || error.message
    );

    throw error;
  }
};