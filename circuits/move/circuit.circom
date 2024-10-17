pragma circom 2.2.0;
include "../../node_modules/circomlib/circuits/comparators.circom";

template VerifyMove() {
    signal input playerX;  // Player's current X position
    signal input playerY;  // Player's current Y position
    signal input newX;     // Player's new X position
    signal input newY;     // Player's new Y position
    signal input maxMoveDist;
    signal output out;
    

    signal maxMovSq;
    maxMovSq <== (maxMoveDist * maxMoveDist) + 1;


    signal distX <== (newX - playerX) * (newX - playerX);
    signal distY <== (newY - playerY) * (newY - playerY);
    signal sumMovement <== distX+distY;
    component ltDist = LessThan(250);
    ltDist.in[0] <== sumMovement;
    ltDist.in[1] <== maxMovSq;
    ltDist.out === 1;
    out <== ltDist.out;
}

component main = VerifyMove();
