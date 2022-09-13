pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/mimcsponge.circom";

template Main() {
  signal input userKey;
  signal input userHash;
  signal input msgAttestation;
  signal input msg;

  // Prove that the secret key corresponds to public key.
  component mimcKey = MiMCSponge(1, 220, 1);
  mimcKey.ins[0] <== userKey;
  mimcKey.k <== 0;
  userHash === mimcKey.outs[0];

 // Prove that my secret key was used to generate a group signature for a message.
  component mimcMsg = MiMCSponge(2, 220, 1);
  mimcMsg.ins[0] <== userKey;
  mimcMsg.ins[1] <== msg;
  mimcMsg.k <== 0;
  msgAttestation === mimcMsg.outs[0];

}

component main {public [userHash, msgAttestation, msg]}= Main();
