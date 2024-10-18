include "../../node_modules/circomlib/circuits/comparators.circom";

template SignalModulus (modulo, n) {
    signal input in;
    signal output out;
 
    signal quotient <-- in\modulo;
 
    out <-- in%modulo;
 
    in === quotient*modulo + out;
 
    component lessThan = LessThan(n);
    lessThan.in[0] <== out;
    lessThan.in[1] <== modulo;
    lessThan.out === 1;
}

// template Main() {
//     component m = SignalModulus(3, 100);
//     m.in <== 100;
//     signal output out <== m.out;
// }

// component main = Main();