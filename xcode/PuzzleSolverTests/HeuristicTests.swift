//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
//

import XCTest

class HeuristicTests: XCTestCase {
    func testMisplacedTileCount() {
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
        let distance = function.calculate(rootNode)
        XCTAssertEqual(distance, 6)
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
        let distance = function.calculate(rootNode)
        XCTAssertEqual(distance, 13)
    }

    func testEucledianDistance() {
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
        let function = EuclideanDistance(goalState: goalState)
        let distance = function.calculate(rootNode)
        let expected =
            rootState.sequence.reduce(Float(0)) { memo, val in
                if val == kEmptyTile {
                    return memo
                }
                return memo +
                    sqrt(
                        pow(Float(rootState.positionOf(val)!.col) - Float(goalState.positionOf(val)!.col), 2) +
                        pow(Float(rootState.positionOf(val)!.row) - Float(goalState.positionOf(val)!.row), 2)
                    )
            }
        XCTAssertEqual(distance, expected)
    }

    func testChebyshevDistance() {
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
        let function = ChebyshevDistance(goalState: goalState)
        let distance = function.calculate(rootNode)
        let expected =
            rootState.sequence.reduce(Float(0)) { memo, val in
                if val == kEmptyTile {
                    return memo
                }
                return memo +
                    max(
                        abs(Float(rootState.positionOf(val)!.col) - Float(goalState.positionOf(val)!.col)),
                        abs(Float(rootState.positionOf(val)!.row) - Float(goalState.positionOf(val)!.row))
                    )
        }
        XCTAssertEqual(distance, expected)
    }
}
