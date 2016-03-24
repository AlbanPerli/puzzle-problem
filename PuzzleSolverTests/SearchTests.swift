//
//  TestBreadthFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest
import Darwin

///
/// Generates a random state that is no larger than the `width` provides
/// - Parameter width: The maximum allowable generated width
/// - Returns: A new random state that is always solvable in a shuffled order
/// - Remarks: The state is always an `n` by `n` state due to solvability
///            constraints
///
func randomState(width inputWidth: UInt32) -> State {
    let width = Int(arc4random_uniform(inputWidth) + 2) // at least 2x2
    let isOdd = width % 2 != 0
    // Generate a sequence of random numbers width^2 long
    func generateSequence() -> [Int] {
        let highest = width * width
        var data: [Int] = Array(count: highest, repeatedValue: -1)
        // Generate random sequence of numbers from [0..highest]
        data.enumerate().forEach { (index: Int, element: Int) -> () in
            let uintHighest = UInt32(highest)
            var num = Int(arc4random_uniform(uintHighest))
            while data.contains(num) {
                num = Int(arc4random_uniform(uintHighest))
            }
            data[index] = num
        }
        return data
    }
    // Validates the sequence generated using solvability proofs
    // See http://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html
    func validateSequence(seq: [Int]) -> Bool {
        let inversions = seq.enumerate().reduce(0) { (memo, value) -> Int in
            let startAt = value.index + 1
            let element = value.element
            var numInversionsForElement = 0
            for num in seq.suffixFrom(startAt) {
                if element > num && num != kEmptyTile {
                    numInversionsForElement += 1
                }
            }
            return memo + numInversionsForElement
        }
        let evenInversions = inversions % 2 == 0
        var matrix = generateMatrix(seq)
        var stateFromSequence = State(matrix: matrix)
        var posOfBlank = stateFromSequence.blankTilePosition
        while posOfBlank == nil {
            matrix = generateMatrix(seq)
            stateFromSequence = State(matrix: matrix)
            posOfBlank = stateFromSequence.blankTilePosition
        }
        let rowFromBottom = (stateFromSequence.height - 1) - posOfBlank!.row
        let blankOnOddRowFromBottom = rowFromBottom % 2 != 0
        // ( (grid width odd ) && (#inversions even) )  ||
        // ( (grid width even) && ((blank on odd row from bottom) == (#inversions even)) )
        return ( isOdd && evenInversions ) || ( !isOdd && (blankOnOddRowFromBottom == evenInversions) )
    }
    // Generates a matrix from a sequence list
    func generateMatrix(seq: [Int]) -> Matrix {
        var data = seq
        let matrix = (0...width-1).map { index -> [Int] in
            return (0...width-1).reduce([]) { (memo, value) -> [Int] in
                return memo + [data.popLast()!]
            }
        }
        return matrix
    }
    var seq = generateSequence()
    while !validateSequence(seq) {
        seq = generateSequence()
    }
    return State(matrix: generateMatrix(seq))
}

class StaticStateSearchTests: XCTestCase {
    // Goal state for static tests
    private let goalStates = [
        "easy": State(matrix:[
            [0,1,2],
            [3,4,5],
            [6,7,8]
        ]),
        "hard": State(matrix:[
            [6,3,1],
            [5,0,2],
            [7,4,8]
        ])
    ]

    private func search(method: SearchMethod) {
        // Set up a multidirectional node
        let rootNodeState = State(matrix: [
            [3,4,1],
            [6,0,2],
            [5,7,8]
        ])
        let rootNode = Node(initialState: rootNodeState)

        XCTestCase.defaultPerformanceMetrics()

        let expectedActions: [Action] = [
            Action(movingPosition: (1,1), inDirection: .Up),
            Action(movingPosition: (0,1), inDirection: .Right),
            Action(movingPosition: (0,2), inDirection: .Down),
            Action(movingPosition: (1,2), inDirection: .Down),
            Action(movingPosition: (2,2), inDirection: .Left),
            Action(movingPosition: (2,1), inDirection: .Left),
            Action(movingPosition: (2,0), inDirection: .Up),
            Action(movingPosition: (1,0), inDirection: .Right),
            Action(movingPosition: (1,1), inDirection: .Down),
            Action(movingPosition: (2,1), inDirection: .Right),
            Action(movingPosition: (2,2), inDirection: .Up),
            Action(movingPosition: (1,2), inDirection: .Left),
            Action(movingPosition: (1,1), inDirection: .Left),
            Action(movingPosition: (1,0), inDirection: .Up)
        ]

        var actions: [Action] = []

        measureBlock {
            actions = method.traverse(rootNode)!
        }

        XCTAssert(actions.count == expectedActions.count)
        XCTAssert(actions == expectedActions)
    }
    func testBFSEasy() {
        let method = BreadthFirstSearch(goalState: goalStates["easy"]!)
        search(method)
    }
    func testDFSEasy() {
        let method = DepthFirstSearch(goalState: goalStates["easy"]!)
        search(method)
    }
    func testBFSHard() {
        let method = BreadthFirstSearch(goalState: goalStates["hard"]!)
        search(method)
    }
    func testDFSHard() {
        let method = DepthFirstSearch(goalState: goalStates["hard"]!)
        search(method)
    }
}