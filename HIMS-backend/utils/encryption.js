import forge from "node-forge";

export const encryptData = (
  publicKey,
  plainText
) => {

  try {

    // Convert key to PEM format
    const pemPublicKey =
`-----BEGIN PUBLIC KEY-----
${publicKey}
-----END PUBLIC KEY-----`;

    // Read public key
    const publicKeyObj =
      forge.pki.publicKeyFromPem(
        pemPublicKey
      );

    // Encrypt using ABDM required algorithm
    const encrypted =
      publicKeyObj.encrypt(
        plainText,
        "RSA-OAEP",
        {
          md: forge.md.sha1.create(),
          mgf1: {
            md: forge.md.sha1.create(),
          },
        }
      );

    // Convert to Base64
    return forge.util.encode64(
      encrypted
    );

  } catch (error) {

    console.error(
      "Encryption Error:",
      error.message
    );

    throw error;
  }
};