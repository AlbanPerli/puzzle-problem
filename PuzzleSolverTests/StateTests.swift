//
//  COS30019 Introduction to AI
//  Assignment 1
//
//  Alex Cummuado 1744070
//

import XCTest

class StateTest: XCTestCase {
    private let testMatrix: Matrix = [
        [0,1,2 ,3 ],
        [4,5,6 ,7 ],
        [8,9,10,11]
    ]
    
    func testElementAt() {
        let state: State = State(matrix: testMatrix)
        
        // Test top left is 0
        let topLeft = (0, 0)
        var test = try! state.elementAt(topLeft) == 0
        XCTAssert(test, "Element at {0,0} is not 0")
        
        // Test bottom right is 11
        let bottomRight = (2, 3)
        test = try! state.elementAt(bottomRight) == 11
        XCTAssert(test, "Element at {2,3} is not 11")
        
        // Test negative element
        do {
            let negativeElement = (-1, -1)
            try state.elementAt(negativeElement)
            XCTFail("Exception should have been thrown here")
        } catch State.InvalidAccessError.NegativeAccess {
            // OK
        } catch {
            XCTFail("Expected NegativeAccess exception")
        }
        
        // Test element out of bounds
        do {
            let tooHighElement = (999, 999)
            try state.elementAt(tooHighElement)
            XCTFail("Exception should have been thrown here")
        } catch State.InvalidAccessError.OutOfBounds {
            // OK
        } catch {
            XCTFail("Expected OutOfBounds exception")
        }
        
        // Test optionals
        let element1 = state[999, 999]
        XCTAssertNil(element1, "Element at {999,999} is nil")
        
        let element2 = state[-1, -1]
        XCTAssertNil(element2, "Element at {-1,-1} is nil")
    }
    
    func testIsValidMove() {
        let state: State = State(matrix: testMatrix)
        
        // Cannot move tile off board
        var test = state.isValidMove((0,0), direction: .Up) == false
        XCTAssert(test, "Tile at {0,0} cannot move up")

        // Swap 0 and 4 - valid move as 0 is blank tile
        test = state.isValidMove((1,0), direction: .Up) == true
        XCTAssert(test, "Tile at {1,0} can move up")
        
        // Swap 0 and 1 - valid move as 0 is blank tile
        test = state.isValidMove((0,1), direction: .Left) == true
        XCTAssert(test, "Tile at {0,1} can move left")
        
        // Swap 1 and 2 - not valid move as not moving blank tile
        test = state.isValidMove((1,0), direction: .Right) == false
        XCTAssert(test, "Tile at {1,0} cannot move up")
    }
    
    func testMatrixEquality() {
        var anotherTestMatrix: [[Int]] = [
            [0,1,2 ,3 ],
            [4,5,6 ,7 ],
            [8,9,10,11]
        ]
        let state1: State = State(matrix: testMatrix)
        let state2: State = State(matrix: anotherTestMatrix)
        
        // Test equality
        XCTAssert(state1 == state2, "Tile at {1,0} cannot move up")
        
        // Reverse
        anotherTestMatrix = anotherTestMatrix.reverse()
        
        // Test inequality
        let state3: State = State(matrix: anotherTestMatrix)
        XCTAssert(state1 != state3, "Tile at {1,0} cannot move up")
    }

    func testPerformAction() {
        let state: State = State(matrix: testMatrix)
        let expectedStateMatrix: Matrix = [
            [1,0,2 ,3 ],
            [4,5,6 ,7 ],
            [8,9,10,11]
        ]
        let newState = state.performAction((0,1), direction: .Left)
        let expectedState = State(matrix: expectedStateMatrix)
        XCTAssert(newState == expectedState)
    }
}
