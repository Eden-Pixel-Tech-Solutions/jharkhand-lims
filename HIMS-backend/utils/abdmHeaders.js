import crypto from "crypto";
import moment from "moment";

export const getAbdmHeaders = (
  accessToken = null
) => {

  const headers = {
    "Content-Type": "application/json",

    "REQUEST-ID":
      crypto.randomUUID(),

    "TIMESTAMP":
      moment()
        .utc()
        .format(
          "YYYY-MM-DDTHH:mm:ss.SSS[Z]"
        ),

    "X-CM-ID": "sbx"
  };

  if (accessToken) {
    headers.Authorization =
      `Bearer ${accessToken}`;
  }

  return headers;
};