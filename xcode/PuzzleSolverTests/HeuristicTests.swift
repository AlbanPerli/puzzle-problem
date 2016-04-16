//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
//

import XCTest

class HeuristicTests: XCTestCase {
    func testEuclidean() {
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
        let function = MisplacedTilesCount(goalState: goalState)
        let numEuclideans = function.visit(rootNode)
        XCTAssertEqual(numEuclideans, 6)
    }

    func testManhattanDistance() {
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
        let function = ManhattanDistance(goalState: goalState)
        let numEuclideans = function.visit(rootNode)
        XCTAssertEqual(numEuclideans, 13)
    }
}
