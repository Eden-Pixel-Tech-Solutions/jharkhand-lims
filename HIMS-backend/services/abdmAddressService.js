import axios from "axios";

import {
  getAbdmHeaders
} from "../utils/abdmHeaders.js";


export const createAbhaAddress =
async (
  accessToken,
  txnId,
  abhaAddress
) => {

  try {

    const response =
      await axios.post(

      "https://abhasbx.abdm.gov.in/abha/api/v3/enrollment/enrol/abha-address",

      {
        txnId,
        abhaAddress,
        preferred: 1
      },

      {
        headers:
          getAbdmHeaders(accessToken)
      }
    );

    return response.data;

  } catch (error) {

    console.error(
      "ABHA Address Error:",
      error.response?.data ||
      error.message
    );

    throw error;
  }
};