import axios from "axios";
import crypto from "crypto";
import moment from "moment";

export const getPublicCertificate = async (
  accessToken
) => {

  try {

    const response = await axios.get(
      "https://abhasbx.abdm.gov.in/abha/api/v3/profile/public/certificate",
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

          "X-CM-ID": "sbx"
        },
      }
    );

    return response.data;

  } catch (error) {

    console.error(
      "Certificate Error:",
      error.response?.data ||
      error.message
    );

    throw error;
  }
};