//
//  COS30019 Introduction to AI
//  Assignment 1
//
//  Alex Cummuado 1744070
//

import XCTest

class NodeTests: XCTestCase {
    func testTwoChildNodes() {
        // With this state there are two possible outcomes
        //
        // 1 2  Move (1,1) UP    1 0
        // 3 0  ->               3 2
        // 
        // 1 2  Move (1,1) LEFT  1 2
        // 3 0  ->               0 3
        //
        let state = State(matrix: [
            [1,2],
            [3,0]
        ])
        var node: Node = Node(initialState: state)
        XCTAssert(node.pathCost == 0)
        XCTAssert(node.state == state)
        let children = node.children
        let moveUpState = State(matrix: [
            [1,0],
            [3,2]
        ])
        let moveLeftState = State(matrix: [
            [1,2],
            [0,3]
        ])
        XCTAssert(children.count == 2)
        XCTAssert(children.contains({ node -> Bool in
            node.state == moveLeftState
        }))
        XCTAssert(children.contains({ node -> Bool in
            node.state == moveUpState
        }))
    }

    func testFourChildNodes() {
        // Set up a multidirectional node
        let rootNodeState = State(matrix: [
            [1,2,4],
            [3,0,5],
            [6,7,8]
        ])
        var rootNode = Node(initialState: rootNodeState)
        // 1 2 4 -> 1 0 4
        // 3 0 5    3 2 5
        // 6 7 8    6 7 8
        let moveBlankUp = State(matrix: [
            [1,0,4],
            [3,2,5],
            [6,7,8]
        ])
        // 1 2 4 -> 1 2 4
        // 3 0 5    3 7 5
        // 6 7 8    6 0 8
        let moveBlankDown = State(matrix: [
            [1,2,4],
            [3,7,5],
            [6,0,8]
        ])
        // 1 2 4 -> 1 2 4
        // 3 0 5    0 3 5
        // 6 7 8    6 7 8
        let moveBlankLeft = State(matrix: [
            [1,2,4],
            [0,3,5],
            [6,7,8]
        ])
        // 1 2 4 -> 1 2 4
        // 3 0 5    3 5 0
        // 6 7 8    6 7 8
        let moveBlankRight = State(matrix: [
            [1,2,4],
            [3,5,0],
            [6,7,8]
        ])

        // When all else is equal, nodes should be expanded according to the
        // following order: the agent should try to move the empty cell UP 
        // before attempting LEFT, before attempting DOWN, before attempting
        // RIGHT, in that order. Let's test that now:
        XCTAssert(rootNode.children[0].state! == moveBlankUp)
        XCTAssert(rootNode.children[1].state! == moveBlankLeft)
        XCTAssert(rootNode.children[2].state! == moveBlankDown)
        XCTAssert(rootNode.children[3].state! == moveBlankRight)
        // Assert we only have 4 children
        XCTAssert(rootNode.children.count == 4)
    }
}