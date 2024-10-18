pragma circom 2.2.0;
include "../../node_modules/circomlib/circuits/poseidon.circom";
include "../../node_modules/circomlib/circuits/mimcsponge.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";
include "../modulo/circuit.circom";
template UpgradeWeaponCheck() {
    var SQRT_P = 1000000000000000000000000000000000000;
    var DENOMINATOR_BITS = 61;
    var divisor = 100;
    // Inputs
    signal input weaponNonce;     // Weapon's unique nonce
    signal input weaponLevel;     // Weapon's current level
    signal input weaponId;        // Unique weapon identifier
    signal input upgradeChance;   // Upgrade chance (value between 0 and 99)
    signal input seed;   // Upgrade chance (value between 0 and 99)

    // Output
    signal output weaponId_;        // 1 if upgrade successful, 0 if not
    signal output success;        // 1 if upgrade successful, 0 if not
    signal output oldNonce;        // 1 if upgrade successful, 0 if not
    signal output oldLevel;        // 1 if upgrade successful, 0 if not
    signal output newNonce;        // 1 if upgrade successful, 0 if not
    signal output newLevel;        // 1 if upgrade successful, 0 if not
    signal output upChance;        // 1 if upgrade successful, 0 if not
    signal output roll;        // 1 if upgrade successful, 0 if not
    signal output seed_;        // 1 if upgrade successful, 0 if not
    
    // Hash weaponNonce, weaponLevel, and weaponId to create a pseudo-random value
    signal inputs[3];
    inputs[0] <== weaponNonce*weaponNonce*13;
    inputs[1] <== weaponLevel;
    inputs[2] <== weaponId * 64;

    // Hash these inputs using Poseidon hash function
    // component hash = Poseidon(3);
    // hash.inputs[0] <== inputs[0];
    // hash.inputs[1] <== inputs[1];
    // hash.inputs[2] <== inputs[2];
    signal hashOut;

    component mimc = MiMCSponge(3, 12, 1);
    mimc.ins[0] <== inputs[0];
    mimc.ins[1] <== inputs[1];
    mimc.ins[2] <== inputs[2];
    mimc.k <== weaponNonce;

    component num2Bits = Num2Bits(254);
    num2Bits.in <== mimc.outs[0] + seed;
    hashOut <== seed + (num2Bits.out[3] * 8 + num2Bits.out[2] * 4 + num2Bits.out[1] * 2 + num2Bits.out[0]) * 31239420;
// Step 2: Range reduction (simulating % 100 using subtraction)


    signal remainder;
    component modulo_ = Modulo(DENOMINATOR_BITS);
    modulo_.dividend <== hashOut;
    modulo_.divisor <== divisor;
    remainder <== modulo_.remainder;
    // Step 3: Compare the remainder (simulated d100 roll) with the upgradeChance
    signal isSuccessful;
    component checkUpgrade = LessThan(100);
    checkUpgrade.in[0] <== remainder;
    checkUpgrade.in[1] <== upgradeChance;

    isSuccessful <== checkUpgrade.out;

    
    // Output the success signal
    weaponId_ <== weaponId;
    success <== isSuccessful;
    oldNonce <== weaponNonce;
    oldLevel <== weaponLevel;
    newNonce <== oldNonce+1;
    newLevel <== weaponLevel+1;
    upChance <== upgradeChance;
    roll <== remainder;
    seed_ <== seed;
}

component main = UpgradeWeaponCheck();
