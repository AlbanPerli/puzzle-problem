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
        var actn = Action(movingPosition: (0,0), inDirection: .Up)
        var test = state.isValidAction(actn) == false
        XCTAssert(test, "Tile at {0,0} cannot move up")

        // Swap 0 and 4 - valid move as 0 is blank tile
        actn = Action(movingPosition: (1,0), inDirection: .Up)
        test = state.isValidAction(actn) == true
        XCTAssert(test, "Tile at {1,0} can move up")
        
        // Swap 0 and 1 - valid move as 0 is blank tile
        actn = Action(movingPosition: (0,1), inDirection: .Left)
        test = state.isValidAction(actn) == true
        XCTAssert(test, "Tile at {0,1} can move left")
        
        // Swap 1 and 2 - not valid move as not moving blank tile
        actn = Action(movingPosition: (1,0), inDirection: .Right)
        test = state.isValidAction(actn) == false
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
        let action = Action(movingPosition: (0,1), inDirection: .Left)
        let newState = state.performAction(action)
        // Expected state
        let expectedState = State(matrix: [
            [1,0,2 ,3 ],
            [4,5,6 ,7 ],
            [8,9,10,11]
        ])
        XCTAssert(newState == expectedState)
        // No answer
        let noAnswerState = State(matrix: [
            [1,2,2 ,3 ],
            [4,5,6 ,7 ],
            [8,9,10,11]
        ])
        let noState = noAnswerState.performAction(action)
        XCTAssertNil(noState)
    }

    func testBlankTile() {
        // Top left
        var pos: Position? = State(matrix: [
            [0,2,3 ,4 ],
            [4,5,6 ,3 ],
            [8,9,10,11]
        ]).blankTilePosition
        XCTAssert(pos! == (0,0))
        // 1 x 4
        pos = State(matrix: [
            [1,2,0 ,4 ]
        ]).blankTilePosition
        XCTAssert(pos! == (0,2))
        // 4 x 1
        pos = State(matrix: [
            [1],
            [2],
            [0],
            [4]
        ]).blankTilePosition
        XCTAssert(pos! == (2,0))
        // 4 x 3
        pos = State(matrix: [
            [1,3,4],
            [2,5,6],
            [1,0,9],
            [6,7,4]
        ]).blankTilePosition
        XCTAssert(pos! == (2,1))
        // Bottom right
        pos = State(matrix: [
            [1,2,3 ,4 ],
            [4,5,6 ,9 ],
            [3,9,10,0 ]
            ]).blankTilePosition
        XCTAssert(pos! == (2,3))
        // No blank tile
        pos = State(matrix: [
            [1,2,3 ,4 ],
            [4,5,6 ,5 ],
            [8,9,10,11]
        ]).blankTilePosition
        XCTAssertNil(pos)
    }

    func testAnyBlankTile() {
        let state: State = randomState(width: 6)
        var expected: Position = (0,0)
        for (rowIdx, row) in state.matrix.enumerate() {
            for (colIdx, _) in row.enumerate() {
                let pos: Position = (rowIdx, colIdx)
                if let element = state[pos] where element == kEmptyTile {
                    expected = pos
                }
            }
        }
        print(state)
        XCTAssert(expected == state.blankTilePosition!)
    }

    func testWidth() {
        let state: State = State(matrix: testMatrix)
        XCTAssert(state.width == 4)
        let emptyState: State = State(matrix: [])
        XCTAssert(emptyState.width == 0)
    }

    func testHeight() {
        let state: State = State(matrix: testMatrix)
        XCTAssert(state.height == 3)
        let emptyState: State = State(matrix: [])
        XCTAssert(emptyState.height == 0)
    }
}
