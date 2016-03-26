//
//  COS30019 Introduction to AI
//  Assignment 1
//
//  Alex Cummuado 1744070
//

import XCTest

class ActionTests: XCTestCase {
    func testInverse() {
        let pos = (1,1)
        // Check each of the moving all directions
        // 1 2 4 -> 1 0 4
        // 3 0 5    3 2 5
        // 6 7 8    6 7 8
        var atn = Action(movingPosition: pos, inDirection: .Up) // To move 0 up...
        XCTAssert(atn.inverse.position  == (0,1))               // we move 2 (at {0,1})
        XCTAssert(atn.inverse.direction == .Down)               // down

        // 1 2 4 -> 1 2 4
        // 3 0 5    3 7 5
        // 6 7 8    6 0 8
        atn = Action(movingPosition: pos, inDirection: .Down) // To move 0 down...
        XCTAssert(atn.inverse.position == (2,1))              // we move 7 (at {2,1})
        XCTAssert(atn.inverse.direction == .Up)               // up

        // 1 2 4 -> 1 2 4
        // 3 0 5    0 3 5
        // 6 7 8    6 7 8
        atn = Action(movingPosition: pos, inDirection: .Left) // To move 0 left...
        XCTAssert(atn.inverse.position == (1,0))              // we move 3 (at {1,0})
        XCTAssert(atn.inverse.direction == .Right)            // right
        // 1 2 4 -> 1 2 4
        // 3 0 5    3 5 0
        // 6 7 8    6 7 8
        atn = Action(movingPosition: pos, inDirection: .Right) // To move 0 right...
        XCTAssert(atn.inverse.position == (1,2))               // we move 5 (at {1,2})
        XCTAssert(atn.inverse.direction == .Left)              // left
        // Check that it isn't breaking
        // To move 0 right we don't move 2 down!
        XCTAssert(atn.inverse.position != (0,1))
        XCTAssert(atn.inverse.direction != .Down)
    }
}