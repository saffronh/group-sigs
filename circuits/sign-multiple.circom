pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/mimcsponge.circom";

template Main(nMembers) {
  signal input hashes[nMembers];
  signal input msg;
  signal input userKey;

  // Intermediate variables
  signal userHash;
  signal temp[nMembers];

  // Output variable
  signal output msgAttestation;

  // MiMC-hash the secret userKey.
  component mimcKey = MiMCSponge(1, 220, 1);
  mimcKey.ins[0] <== userKey;
  mimcKey.k <== 0;
  userHash <== mimcKey.outs[0];

  // Compare the user's public hash to the list of hashes we have.
  for(var i = 0; i < nMembers; i++){
    if (i > 0) {
      temp[i] <== temp[i-1] * (userHash - hashes[i]);
    } else {
      temp[i] <== userHash - hashes[i];
    }
  }
  0 === temp[nMembers-1];

  // User is valid group member. "Sign" the message with their key by MiMC-hashing together.
  component mimcMsg = MiMCSponge(2, 220, 1);
  mimcMsg.ins[0] <== userKey;
  mimcMsg.ins[1] <== msg;
  mimcMsg.k <== 0;
  msgAttestation <== mimcMsg.outs[0];

}

component main {public [hashes, msg]}= Main(3);
