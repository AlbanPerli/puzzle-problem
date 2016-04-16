//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
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
        let rootNode = Node(initialState: rootState)
        let function = MisplacedTileHeuristic(goalState: goalState)
        let numMisplacedTiles = function.visit(rootNode)
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
        let rootNode = Node(initialState: rootState)
        let function = DistanceToGoalHeuristic(goalState: goalState)
        let numMisplacedTiles = function.visit(rootNode)
        XCTAssertEqual(numMisplacedTiles, 13)
    }
}
