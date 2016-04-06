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
        let node: Node = Node(initialState: state)
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
        let rootNode = Node(initialState: rootNodeState)
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
        XCTAssert(rootNode.children[0].state == moveBlankUp)
        XCTAssert(rootNode.children[1].state == moveBlankLeft)
        XCTAssert(rootNode.children[2].state == moveBlankDown)
        XCTAssert(rootNode.children[3].state == moveBlankRight)
        // Assert we only have 4 children
        XCTAssert(rootNode.children.count == 4)
    }
    
    func testChildren() {
        let state = State(matrix: [
            [1,2],
            [3,0]
            ])
        let node: Node = Node(initialState: state)
        let expectedChildren = [
            Node(parent: node,
                 state: node.state.performActionTo((1,1), inDirection: .Up)),
            Node(parent: node,
                 state: node.state.performActionTo((1,1), inDirection: .Left))
        ]
        XCTAssertEqual(node.children, expectedChildren)
    }
    
    func testAnsestors() {
        let state = State(matrix: [
            [1,2],
            [3,0]
        ])
        let node: Node = Node(initialState: state)
        // 1 0
        // 3 2
        let applyUpNode = Node(parent: node,
                               state: node.state.performActionTo((1,1), inDirection: .Up))
        // 0 1
        // 3 2
        let applyLeftNode = Node(parent: applyUpNode,
                                 state: applyUpNode.state.performActionTo((0,1), inDirection: .Left))
        // 3 1
        // 0 2
        let applyDownNode = Node(parent: applyLeftNode,
                                 state: applyLeftNode.state.performActionTo((0,0), inDirection: .Down))
        // 3 1
        // 2 0
        let applyRightNode = Node(parent: applyDownNode,
                                  state: applyDownNode.state.performActionTo((1,0), inDirection: .Right))
        let expectedAnsestors = [
            applyRightNode,
            applyDownNode,
            applyLeftNode,
            applyUpNode,
            node
        ]
        XCTAssertEqual(applyRightNode.ansecstors, expectedAnsestors)
    }
}