// SPDX-License-Identifier: GPL3.0
pragma solidity 0.8.27;

import {LibAppStorage, Modifiers} from "../Libraries/LibAppStorage.sol";
import {Coords, Plot} from "../Objects/GameObjects.sol";
// import {LibPerlinNoise} from "../Libraries/LibPerlinNoise.sol";
import {LibPerlinBySeed} from "../Libraries/LibPerlinBySeed.sol";
// import {LibTrigonometry} from "../Libraries/LibTrigonometry.sol";

contract WorldFacet is Modifiers {
    // function sin(uint16 x) internal pure returns (int) {
    //     return LibTrigonometry.sin(x);
    // }

    function getWorldSeed() public view returns (uint _seed) {
        _seed = block.timestamp % 1000;
    }

    function getWorldScale() internal pure returns (uint worldScale) {
        worldScale = 25;
    }

    function generatePlotContent(
        Coords memory coords
    ) public view returns (Plot memory _plot) {
        // if (_coords.x > type(int16).max) {
        //     _coords.x = type(int16).max;
        // }
        // if (_coords.x < type(int16).min) {
        //     _coords.x = type(int16).min;
        // }
        // if (_coords.y > type(int16).max) {
        //     _coords.y = type(int16).max;
        // }
        // if (_coords.y < type(int16).min) {
        //     _coords.y = type(int16).min;
        // }

        // _plot.Temperature = LibPerlinNoise.noise2d(
        //     sin(uint16(uint24(_coords.x) % type(uint16).max)) * 64,
        //     sin(uint16(uint24(_coords.y) % type(uint16).max)) * 64
        uint seed = getWorldSeed();
        uint ws = getWorldScale();

        uint256 perlin1 = LibPerlinBySeed.computePerlin(
            uint32(coords.x),
            uint32(coords.y),
            uint32(seed),
            uint32(ws)
        );

        uint256 perlin2 = LibPerlinBySeed.computePerlin(
            uint32(coords.x),
            uint32(coords.y),
            uint32(seed + 1),
            uint32(ws)
        );

        uint256 radioactivity = perlin1;
        uint256 temperature = perlin2;
        _plot.Temperature = uint256(int256(temperature) + (int256(uint(coords.x)) - 25) / 2); // uint256(int256(temperature) + (int256(uint(coords.x)) - 50) / 2);
        _plot.Radioactivity = radioactivity;
    }

    // function generateNumberFromCoordsAndSeed(
    //     Coords memory coords
    // ) internal view returns (uint) {
    //     uint random = uint256(
    //         keccak256(
    //             abi.encodePacked(coords.x, coords.y, address(this), uint(1337))
    //         )
    //     );
    //     return random;
    // }

    // function useRandom(
    //     Coords memory coords,
    //     uint seed,
    //     uint modulus
    // ) internal view returns (uint) {
    //     return (generateNumberFromCoordsAndSeed(coords) % modulus) + 1;
    // }
}
