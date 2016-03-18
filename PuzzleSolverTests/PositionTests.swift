//
//  COS30019 Introduction to AI
//  Assignment 1
//
//  Alex Cummuado 1744070
//

import XCTest

class PositionTests: XCTestCase {
    func testPositionMove() {
        let pos = (1,1)
        var new = movePositionIn(pos, direction: .Up)
        // Check each of the moving in the positions
        XCTAssert(new == (0,1))
        new = movePositionIn(pos, direction: .Down)
        XCTAssert(new == (2,1))
        new = movePositionIn(pos, direction: .Left)
        XCTAssert(new == (1,0))
        new = movePositionIn(pos, direction: .Right)
        XCTAssert(new == (1,2))
        // Check that it isn't breaking
        XCTAssert(new != (0,1))
    }
}