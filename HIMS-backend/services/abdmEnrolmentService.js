import axios from "axios";
import { getAbdmHeaders }
    from "../utils/abdmHeaders.js";

export const enrolByAadhaar = async (
    accessToken,
    txnId,
    encryptedOtp,
    mobile
) => {

    try {

        const response = await axios.post(
            "https://abhasbx.abdm.gov.in/abha/api/v3/enrollment/enrol/byAadhaar",

            {
                authData: {

                    authMethods: [
                        "otp"
                    ],

                    otp: {
                        txnId,
                        otpValue: encryptedOtp,
                        mobile
                    }
                },

                consent: {
                    code: "abha-enrollment",
                    version: "1.4"
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
            "ABHA Enrolment Error:",
            error.response?.data ||
            error.message
        );

        throw error;
    }
};