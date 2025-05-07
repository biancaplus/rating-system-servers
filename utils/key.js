const path = require("path");
const fs = require("fs");
const forge = require("node-forge");

const privateKeyPath = path.resolve(__dirname, "../private.pem");
const privateKeyPem = fs.readFileSync(privateKeyPath, "utf8");
const privateKey = forge.pki.privateKeyFromPem(privateKeyPem);

module.exports = {
  privateKey,
};
