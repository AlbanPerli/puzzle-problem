//
//  HeuristicTests.swift
//  PuzzleProblem
//
//  Created by Alex on 25/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class HeuristicTests: XCTestCase {
    func testMisplacedTile() {
        let rootState = State(matrix: [
            [5, 0, 8],
            [4, 2, 1],
            [7, 3, 6],
        ])
        let goalState = State(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 0],
        ])
        let function = MisplacedTileHeuristic(goalState: goalState)
        let numMisplacedTiles = rootState.performHeuristic(function)
        XCTAssertEqual(numMisplacedTiles, 6)
    }

    func testDistanceToGoal() {
        let rootState = State(matrix: [
            [5, 0, 8],
            [4, 2, 1],
            [7, 3, 6],
            ])
        let goalState = State(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 0],
            ])
        let function = DistanceToGoalHeuristic(goalState: goalState)
        let numMisplacedTiles = rootState.performHeuristic(function)
        XCTAssertEqual(numMisplacedTiles, 13)
    }
}
