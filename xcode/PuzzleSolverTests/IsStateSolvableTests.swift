//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           4/04/2016
//

import XCTest

class IsStateSolvableTests: XCTestCase {
    // These states are impossible to solve
    func testImpossibleToSolve() {
        XCTAssertFalse(State(sequence: [6,7,4,1,5,3,8,0,2], height: 3, width: 3).isSolvable)
        XCTAssertFalse(State(sequence: [3,4,2,1,8,7,6,0,5], height: 3, width: 3).isSolvable)
        XCTAssertFalse(State(sequence: [4,5,0,1,3,2],       height: 2, width: 3).isSolvable)
        XCTAssertFalse(State(sequence: [0,7,2,1,4,6,3,5],   height: 2, width: 4).isSolvable)
        XCTAssertFalse(State(sequence: [4,7,6,5,1,3,0,2],   height: 2, width: 4).isSolvable)
        // Assert 100,000 times!
        for _ in 0...100000 {
            XCTAssertFalse(randomState(5, cols: 5, isSolvable: false).isSolvable)
        }
    }

    // These states are possible to solve
    func testPossibleToSolve() {
        XCTAssertTrue(State(sequence: [6,3,1,5,0,2,7,4,8], height: 3, width: 3).isSolvable)
        XCTAssertTrue(State(sequence: [3,4,1,6,0,2,5,7,8], height: 3, width: 3).isSolvable)
        // Assert 100,000 times!
        for _ in 0...100000 {
            XCTAssertTrue(randomState(5, cols: 5, isSolvable: true).isSolvable)
        }
    }
}