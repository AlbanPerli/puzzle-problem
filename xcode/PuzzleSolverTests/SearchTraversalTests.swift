//
//  SearchTraversalTests.swift
//  PuzzleProblem
//
//  Created by Alex on 1/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class NodesTraversedTests: XCTestCase {
    let goalState = State(matrix: [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0],
    ])
    
    var nodes: Dictionary<String, Node> = [:]
    
    override func setUp() {
        /*              A
         *       ______/ \______
         *      /     /   \     \
         *     B     C     D     E
         *    / \   / \   / \   / \
         *   F   G H   I J   K L   M
         */
        
        //         1 2 3
        // (A) =>  4 0 5
        //         7 8 6
        let rootState = State(matrix: [
            [1, 2, 3],
            [4, 0, 5],
            [7, 8, 6],
        ])
        let action1States = [
            //      1 2 3      1 0 3
            // (B)  4 0 5  =>  4 2 5
            //      7 8 6      7 8 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Up)),
            //      1 2 3      1 2 3
            // (C)  4 0 5  =>  0 4 5
            //      7 8 6      7 8 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Left)),
            //      1 2 3      1 2 3
            // (D)  4 0 5  =>  4 8 5
            //      7 8 6      7 0 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Down)),
            //      1 2 3      1 2 3
            // (E)  4 0 5  =>  4 5 0
            //      7 8 6      7 8 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Right))
        ]
        let action2States = [
            //      1 0 3      0 1 3
            // (F)  4 2 5  =>  4 2 5
            //      7 8 6      7 8 6
            action1States[0].performAction(Action(movingPosition: (0,1), inDirection: .Left)),
            //      1 0 3      1 3 0
            // (G)  4 2 5  =>  4 2 5
            //      7 8 6      7 8 6
            action1States[0].performAction(Action(movingPosition: (0,1), inDirection: .Right)),
            //      1 2 3      0 2 3
            // (H)  0 4 5  =>  1 4 5
            //      7 8 6      7 8 6
            action1States[1].performAction(Action(movingPosition: (1,0), inDirection: .Up)),
            //      1 2 3      1 2 3
            // (I)  0 4 5  =>  7 4 5
            //      7 8 6      0 8 6
            action1States[1].performAction(Action(movingPosition: (1,0), inDirection: .Down)),
            //      1 2 3      1 2 3
            // (J)  4 8 5  =>  4 8 5
            //      7 0 6      0 7 6
            action1States[2].performAction(Action(movingPosition: (2,1), inDirection: .Left)),
            //      1 2 3      1 2 3
            // (K)  4 8 5  =>  4 8 5
            //      7 0 6      7 6 0
            action1States[2].performAction(Action(movingPosition: (2,1), inDirection: .Right)),
            //      1 2 3      1 2 0
            // (L)  4 5 0  =>  4 5 3
            //      7 8 6      7 8 6
            action1States[3].performAction(Action(movingPosition: (1,2), inDirection: .Up)),
            //      1 2 3      1 2 3
            // (M)  4 5 0  =>  4 5 6
            //      7 8 6      7 8 0
            action1States[3].performAction(Action(movingPosition: (1,2), inDirection: .Down))
        ]
        
        // Set up traversed nodes
        nodes.updateValue(Node(initialState: rootState),                      forKey: "A")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[0]), forKey: "B")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[1]), forKey: "C")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[2]), forKey: "D")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[3]), forKey: "E")
        nodes.updateValue(Node(parent: nodes["B"]!, state: action2States[0]), forKey: "F")
        nodes.updateValue(Node(parent: nodes["B"]!, state: action2States[1]), forKey: "G")
        nodes.updateValue(Node(parent: nodes["C"]!, state: action2States[2]), forKey: "H")
        nodes.updateValue(Node(parent: nodes["C"]!, state: action2States[3]), forKey: "I")
        nodes.updateValue(Node(parent: nodes["D"]!, state: action2States[4]), forKey: "J")
        nodes.updateValue(Node(parent: nodes["D"]!, state: action2States[5]), forKey: "K")
        nodes.updateValue(Node(parent: nodes["E"]!, state: action2States[6]), forKey: "L")
        nodes.updateValue(Node(parent: nodes["E"]!, state: action2States[7]), forKey: "M")
    }
    
    func testBFSTraversal() {
        // Goes by breadth first FIFO
        // Expect A B C D E F G H I J K L M
        let method = BreadthFirstSearch(goalState: goalState)
        let traversal = method.traverse(nodes["A"]!).nodesTraversed
        let expectedTraversal = [
            nodes["A"]!,
            nodes["B"]!,
            nodes["C"]!,
            nodes["D"]!,
            nodes["E"]!,
            nodes["F"]!,
            nodes["G"]!,
            nodes["H"]!,
            nodes["I"]!,
            nodes["J"]!,
            nodes["K"]!,
            nodes["L"]!,
            nodes["M"]!,
        ]
        XCTAssert(traversal == expectedTraversal)
    }
    
    
    func testDFSTraversal() {
        // Goes by depth first LIFO
        // Expect A B F G C H I D J K E L M
        let method = DepthFirstSearch(goalState: goalState)
        let traversal = method.traverse(nodes["A"]!).nodesTraversed
        let expectedTraversal = [
            nodes["A"]!,
            nodes["B"]!,
            nodes["F"]!,
            nodes["G"]!,
            nodes["C"]!,
            nodes["H"]!,
            nodes["I"]!,
            nodes["D"]!,
            nodes["J"]!,
            nodes["K"]!,
            nodes["E"]!,
            nodes["L"]!,
            nodes["M"]!,
        ]
        XCTAssert(traversal == expectedTraversal)
    }
    
    func testGBFSTraversal() {
        // Goes by best evaluation function
        // Expect A E M
        let heuristic = MisplacedTileHeuristic(goalState: goalState)
        let method = GreedyBestFirstSearch(goalState: goalState, heuristicFunction: heuristic)
        let traversal = method.traverse(nodes["A"]!).nodesTraversed
        let expectedTraversal = [
            nodes["A"]!,
            nodes["E"]!,
            nodes["M"]!,
        ]
        XCTAssert(traversal == expectedTraversal)
    }
    
    func testASTraversal() {
        // Goes by best evaluation function 
        // Expect A E M
        let heuristic = MisplacedTileHeuristic(goalState: goalState)
        let method = AStarSearch(goalState: goalState, heuristicFunction: heuristic)
        let traversal = method.traverse(nodes["A"]!).nodesTraversed
        let expectedTraversal = [
            nodes["A"]!,
            nodes["E"]!,
            nodes["M"]!,
        ]
        XCTAssert(traversal == expectedTraversal)
    }
}