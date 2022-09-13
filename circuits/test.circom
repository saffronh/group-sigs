pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/mimcsponge.circom";

template Main() {
  signal input msg;
  signal input userKey;

  // Output variable
  signal output msgAttestation;
  signal output userHash;

  // MiMC-hash the secret userKey.
  component mimcKey = MiMCSponge(1, 220, 1);
  mimcKey.ins[0] <== userKey;
  mimcKey.k <== 0;
  userHash <== mimcKey.outs[0];

  // "Sign" the message with their key by MiMC-hashing together.
  component mimcMsg = MiMCSponge(2, 220, 1);
  mimcMsg.ins[0] <== userKey;
  mimcMsg.ins[1] <== msg;
  mimcMsg.k <== 0;
  msgAttestation <== mimcMsg.outs[0];

}

component main {public [msg]}= Main();
