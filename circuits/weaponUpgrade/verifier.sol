// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 19642524115522290447760970021746675789341356000653265441069630957431566301675;
    uint256 constant alphay  = 15809037446102219312954435152879098683824559980020626143453387822004586242317;
    uint256 constant betax1  = 6402738102853475583969787773506197858266321704623454181848954418090577674938;
    uint256 constant betax2  = 3306678135584565297353192801602995509515651571902196852074598261262327790404;
    uint256 constant betay1  = 15158588411628049902562758796812667714664232742372443470614751812018801551665;
    uint256 constant betay2  = 4983765881427969364617654516554524254158908221590807345159959200407712579883;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 4481244693175042587217178506851217913476600467396443392182999643036797012128;
    uint256 constant deltax2 = 11899798927993266822822938648195765146044206051722829559178639530618179172899;
    uint256 constant deltay1 = 16520585420902480743973544070046313974272634691981638582315043981743796272302;
    uint256 constant deltay2 = 4820319940017441488981133090309532887039861100999927513776337385448209784285;

    
    uint256 constant IC0x = 6976560218654615301731198158002682064070543483899223373089063336571965348311;
    uint256 constant IC0y = 14475965501992464782882827329338053313118100659536334696189002617311813561165;
    
    uint256 constant IC1x = 7562462464051767956551776776286035803090513923405209696473759591783997215951;
    uint256 constant IC1y = 15169213654757010771613002156103749327194855617060381170592836939978255744889;
    
    uint256 constant IC2x = 4925283726951428944157728411333162835679128771776345230177620963891001460698;
    uint256 constant IC2y = 15301074790618228753512784830896738224225124590855105072104548997622839221725;
    
    uint256 constant IC3x = 18143697053922519286176923611551277378514167079081399728725483063218421172870;
    uint256 constant IC3y = 21339407515041295783019285869617615818439255942519616019784333260722307010382;
    
    uint256 constant IC4x = 15263386635856043968132071686743551841066417716084897317818495011796928379214;
    uint256 constant IC4y = 410979505767018510240268057712843558434101322997203065422585169826453057630;
    
    uint256 constant IC5x = 21417846175028070046107653284151458412660989577872169016012322136500437287325;
    uint256 constant IC5y = 2304440792625126469682642195642755805987289561030710439777832507894163778;
    
    uint256 constant IC6x = 8671753131369477430966654622799139105073171655385160172458706842509010197368;
    uint256 constant IC6y = 9576352835220457451059625453834479393312959045862841782099125766545028049778;
    
    uint256 constant IC7x = 10796124649796602506199236739048237541461267643739934240154538597057948438849;
    uint256 constant IC7y = 3342766226468621362971113528422321248685298256394989834648298036402075900790;
    
    uint256 constant IC8x = 12306294214554034973393700507596764410193943768306598724354551051307834022099;
    uint256 constant IC8y = 8013348146511431924402805576691222204839510290233469385294383907086766866938;
    
    uint256 constant IC9x = 21563178285092913692973404984276258570903074236647862243137895562847007998404;
    uint256 constant IC9y = 21532446663212417022368285147028033134300141109693651667086493789443922172161;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[9] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
