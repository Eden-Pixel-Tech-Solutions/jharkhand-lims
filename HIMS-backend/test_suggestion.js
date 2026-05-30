import axios from 'axios';
import { generateAccessToken } from './services/abdmAuthService.js';
import { getAbdmHeaders } from './utils/abdmHeaders.js';

async function test() {
  try {
    const token = await generateAccessToken();
    console.log("Token:", token.accessToken.substring(0, 10));

    // Test GET
    try {
      const resGet = await axios.get(
        "https://abhasbx.abdm.gov.in/abha/api/v3/enrollment/enrol/suggestion",
        {
          headers: {
            ...getAbdmHeaders(token.accessToken),
            "Transaction-Id": "e4a7ebfa-18c5-481f-acd2-a6dc1165ae46"
          }
        }
      );
      console.log("GET SUCCESS:", resGet.data);
    } catch (e) {
      console.error("GET ERROR:", e.response?.data || e.message);
    }

  } catch (e) {
    console.error(e);
  }
}
test();
