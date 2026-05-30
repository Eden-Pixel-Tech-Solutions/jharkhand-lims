import { getPublicCertificate } from "../services/abdmCertificateService.js";
import { generateAccessToken } from "../services/abdmAuthService.js";
import { encryptData } from "../utils/encryption.js";
import { requestAadhaarOtp } from "../services/abdmAadhaarService.js";
import { enrolByAadhaar } from "../services/abdmEnrolmentService.js";
import {
  sendMobileOtp,
  verifyMobileOtp
} from "../services/abdmMobileService.js";

import {
  requestEmailVerification
} from "../services/abdmEmailService.js";

import {
  getAbhaSuggestions
} from "../services/abdmSuggestionService.js";

import {
  createAbhaAddress
} from "../services/abdmAddressService.js";


export const fetchCertificate = async (req, res) => {
  try {

    // STEP 1 → Generate Session Token
    const tokenData = await generateAccessToken();

    const accessToken = tokenData.accessToken;

    // STEP 2 → Pass Token to Certificate API
    const data = await getPublicCertificate(accessToken);

    res.status(200).json({
      success: true,
      data,
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      error: error.response?.data || error.message,
    });

  }
};

export const generateSession = async (req, res) => {
  try {

    const tokenData = await generateAccessToken();

    res.status(200).json({
      success: true,
      data: tokenData
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      message: 'Failed to generate ABDM session token',
      error: error.response?.data || error.message
    });

  }
};

export const testEncryption = async (req, res) => {
  try {
    const { value } = req.body;

    const tokenData = await generateAccessToken();
    const accessToken = tokenData.accessToken;

    const certData = await getPublicCertificate(accessToken);

    const encrypted = encryptData(certData.publicKey, value);

    res.status(200).json({
      success: true,
      encrypted,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.response?.data || error.message,
    });
  }
};

export const generateAadhaarOtp = async (req, res) => {
  try {
    const { aadhaar } = req.body;

    // STEP 1
    const tokenData = await generateAccessToken();
    const accessToken = tokenData.accessToken;

    // STEP 2
    const certData = await getPublicCertificate(accessToken);

    // STEP 3
    const encryptedAadhaar = encryptData(certData.publicKey, aadhaar);

    // STEP 4
    const otpResponse = await requestAadhaarOtp(accessToken, encryptedAadhaar);

    res.status(200).json({
      success: true,
      data: otpResponse
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.response?.data || error.message
    });
  }
};

export const resendAadhaarOtp = async (req, res) => {
  try {
    const { aadhaar } = req.body;

    // Generate token
    const tokenData = await generateAccessToken();
    const accessToken = tokenData.accessToken;

    // Get cert
    const certData = await getPublicCertificate(accessToken);

    // Encrypt Aadhaar
    const encryptedAadhaar = encryptData(certData.publicKey, aadhaar);

    // Resend OTP = Fresh Request
    const response = await requestAadhaarOtp(accessToken, encryptedAadhaar);

    res.status(200).json({
      success: true,
      data: response
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.response?.data || error.message
    });
  }
};

export const verifyAadhaarOtp = async (req, res) => {
  try {
    const { txnId, otp, mobile } = req.body;

    // Generate access token
    const tokenData = await generateAccessToken();
    const accessToken = tokenData.accessToken;

    // Fetch certificate
    const certData = await getPublicCertificate(accessToken);

    // Encrypt OTP
    const encryptedOtp = encryptData(certData.publicKey, otp);

    // Enrol ABHA
    const response = await enrolByAadhaar(accessToken, txnId, encryptedOtp, mobile);

    res.status(200).json({
      success: true,
      data: response
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.response?.data || error.message
    });
  }
};

export const requestMobileOtp =
async (req, res) => {

  try {

    const {
      txnId,
      mobile
    } = req.body;

    // Generate access token
    const tokenData =
      await generateAccessToken();

    const accessToken =
      tokenData.accessToken;

    // Fetch public certificate
    const certData =
      await getPublicCertificate(
        accessToken
      );

    // Encrypt mobile number
    const encryptedMobile =
      encryptData(
        certData.publicKey,
        mobile
      );

    // Send OTP
    const response =
      await sendMobileOtp(
        accessToken,
        txnId,
        encryptedMobile
      );

    res.status(200).json({
      success: true,
      data: response
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      error:
        error.response?.data ||
        error.message
    });

  }
};

export const verifyMobileOtpController =
async (req, res) => {

  try {

    const {
      txnId,
      otp
    } = req.body;

    // Generate token
    const tokenData =
      await generateAccessToken();

    const accessToken =
      tokenData.accessToken;

    // Fetch certificate
    const certData =
      await getPublicCertificate(
        accessToken
      );

    // Encrypt OTP
    const encryptedOtp =
      encryptData(
        certData.publicKey,
        otp
      );

    // Verify OTP
    const response =
      await verifyMobileOtp(
        accessToken,
        txnId,
        encryptedOtp
      );

    res.status(200).json({
      success: true,
      data: response
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      error:
        error.response?.data ||
        error.message
    });

  }
};

export const sendEmailVerification =
async (req, res) => {

  try {

    const {
      email,
      xToken
    } = req.body;

    // Generate session token
    const tokenData =
      await generateAccessToken();

    const accessToken =
      tokenData.accessToken;

    // Fetch certificate
    const certData =
      await getPublicCertificate(
        accessToken
      );

    // Encrypt email
    const encryptedEmail =
      encryptData(
        certData.publicKey,
        email
      );

    // Send verification link
    const response =
      await requestEmailVerification(
        accessToken,
        xToken,
        encryptedEmail
      );

    res.status(200).json({
      success: true,
      message:
        "Verification email sent"
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      error:
        error.response?.data ||
        error.message
    });

  }
};

export const fetchAbhaSuggestions =
async (req, res) => {

  try {

    const { txnId } =
      req.body;

    // Generate token
    const tokenData =
      await generateAccessToken();

    const accessToken =
      tokenData.accessToken;

    // Get suggestions
    const response =
      await getAbhaSuggestions(
        accessToken,
        txnId
      );

    res.status(200).json({
      success: true,
      data: response
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      error:
        error.response?.data ||
        error.message
    });

  }
};

export const createAbhaAddressController = async (req, res) => {
  try {
    const { txnId, abhaAddress } = req.body;

    const tokenData = await generateAccessToken();
    const accessToken = tokenData.accessToken;

    const response = await createAbhaAddress(accessToken, txnId, abhaAddress);

    res.status(200).json({
      success: true,
      data: response
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.response?.data || error.message
    });
  }
};