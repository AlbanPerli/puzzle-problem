//
//  FrontierTests.swift
//  PuzzleProblem
//
//  Created by Alex on 26/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class FrontierTests: XCTestCase {
    struct MockSearch {
        var explored = Set<Node>()
        var frontier: Frontier
        var nodesToConsider: Dictionary<String, Node>?
        init(frontier: Frontier, nodesToConsider: Dictionary<String, Node>) {
            self.frontier = frontier
            self.nodesToConsider = nodesToConsider
        }
        mutating func push(children: [Node]) {
            let childrenToAdd = children.filter {
                // Only add in frontier and explored (as per normal) but consider only those
                // nodes we have in the nodes dictionary for testing only (let's explore only
                // one branch to ensure the branch is adding them in a correct order)
                !(frontier.contains($0) || explored.contains($0)) && nodesToConsider!.values.contains($0)
            }
            frontier.push(childrenToAdd)
        }
        mutating func pop() -> Node {
            let node = frontier.pop()!
            explored.insert(node)
            return node
        }
    }
    
    func testFifoFrontier() {
        let nodes = [
            Node(initialState: State(matrix: [[1,2,3],[4,5,6],[7,8,0]])),
            Node(initialState: State(matrix: [[5,6,3],[8,4,0],[7,2,1]])),
            Node(initialState: State(matrix: [[0,1,3],[5,4,6],[2,8,7]])),
        ]
        var frontier = FifoFrontier()
        frontier.push(nodes[0])
        XCTAssertEqual(nodes[0], frontier.pop())
        frontier.push(nodes[0])
        frontier.push(nodes[1])
        XCTAssertEqual(nodes[0], frontier.peek())
        XCTAssertEqual(false, frontier.isEmpty)
        XCTAssertEqual(false, frontier.contains(nodes[2]))
        XCTAssertEqual(true, frontier.contains(nodes[1]))
        frontier.push(nodes[2])
        XCTAssertEqual(nodes[0], frontier.pop())
    }
    
    func testLifoFrontier() {
        let nodes = [
            Node(initialState: State(matrix: [[1,2,3],[4,5,6],[7,8,0]])),
            Node(initialState: State(matrix: [[5,6,3],[8,4,0],[7,2,1]])),
            Node(initialState: State(matrix: [[0,1,3],[5,4,6],[2,8,7]])),
        ]
        var frontier = LifoFrontier()
        frontier.push(nodes[0])
        XCTAssertEqual(nodes[0], frontier.pop())
        frontier.push(nodes[0])
        frontier.push(nodes[1])
        XCTAssertEqual(nodes[1], frontier.peek())
        XCTAssertEqual(false, frontier.isEmpty)
        XCTAssertEqual(false, frontier.contains(nodes[2]))
        XCTAssertEqual(true, frontier.contains(nodes[1]))
        frontier.push(nodes[2])
        XCTAssertEqual(nodes[2], frontier.pop())
    }
    
    func testEvaluatedFrontierMisplaced() {
        let rootState = State(matrix: [
            [1, 3, 6],
            [7, 4, 5],
            [0, 8, 2],
        ])
        let firstActionStates = [
            // 1 3 6    1 3 6
            // 7 4 5 => 0 4 5 => 5 misplaced tiles (1.1)
            // 0 8 2    7 8 2
            rootState.performActionTo((2,0), inDirection: .Up),
            // 1 3 6    1 3 6
            // 7 4 5 => 7 4 5 => 7 misplaced tiles (1.2)
            // 0 8 2    8 0 2
            rootState.performActionTo((2,0), inDirection: .Right),
        ]
        let secondActionStates = [
            // 1 3 6    0 3 6
            // 0 4 5 => 1 4 5 => 6 misplaced tiles (1.1.1)
            // 7 8 2    7 8 2
            firstActionStates[0].performActionTo((1,0), inDirection: .Up),
            // 1 3 6    1 3 6
            // 0 4 2 => 4 0 5 => 4 misplaced tiles (1.1.2)
            // 7 8 2    7 8 2
            firstActionStates[0].performActionTo((1,0), inDirection: .Right)
        ]
        let thirdActionStates = [
            // 1 3 6    1 0 6
            // 4 0 5 => 4 3 5 => 4 misplaced tiles (1.1.2.1)
            // 7 8 2    7 8 2
            secondActionStates[1].performActionTo((1,1), inDirection: .Up),
            // 1 3 6    1 3 6
            // 4 0 5 => 4 8 5 => 5 misplaced tiles (1.1.2.2)
            // 7 8 2    7 0 2
            secondActionStates[1].performActionTo((1,1), inDirection: .Down),
            // 1 3 6    1 3 6
            // 4 0 5 => 4 5 0 => 3 misplaced tiles (1.1.2.3)
            // 7 8 2    7 8 2
            secondActionStates[1].performActionTo((1,1), inDirection: .Right)
        ]
        let fourthActionStates = [
            // 1 3 6    1 3 0
            // 4 5 0 => 4 5 6 => 2 misplaced tiles (1.1.2.3.1)
            // 7 8 2    7 8 2
            thirdActionStates[2].performActionTo((1,2), inDirection: .Up),
            // 1 3 6    1 3 6
            // 4 5 0 => 4 5 2 => 3 misplaced tiles (1.1.2.3.2)
            // 7 8 2    7 8 0
            thirdActionStates[2].performActionTo((1,2), inDirection: .Down),
        ]
        // Order should be
        // pop root     1.1       (5), 1.2       (7)
        // pop 1.1      1.1.2     (4), 1.1.1     (6), 1.2     (7)
        // pop 1.1.2    1.1.2.3   (3), 1.1.2.1   (4), 1.1.2.2 (5), 1.1.1   (6), 1.2   (7)
        // pop 1.1.2.3  1.1.2.3.1 (2), 1.1.2.3.2 (3), 1.1.2.1 (4), 1.1.2.2 (5), 1.1.1 (6), 1.2 (7)
        let goalState = State(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 0],
        ])
        // Just use simple heuristic and evaluation
        let heuristic = MisplacedTileHeuristic(goalState: goalState)
        let evaluationFunction = HeuristicOnlyEvaluation(heuristicFunction: heuristic)
        let frontier = EvaluatedFrontier(evaluationFunction: evaluationFunction)
        var nodes: Dictionary<String, Node> = [:]
        nodes.updateValue(Node(initialState: rootState), forKey: "root")
        nodes.updateValue(Node(parent: nodes["root"]!, state: firstActionStates[0]), forKey: "1.1")
        nodes.updateValue(Node(parent: nodes["root"]!, state: firstActionStates[1]), forKey: "1.2")
        nodes.updateValue(Node(parent: nodes["1.1"]!, state: secondActionStates[0]), forKey: "1.1.1")
        nodes.updateValue(Node(parent: nodes["1.1"]!, state: secondActionStates[1]), forKey: "1.1.2")
        nodes.updateValue(Node(parent: nodes["1.1.2"]!, state: thirdActionStates[0]), forKey: "1.1.2.1")
        nodes.updateValue(Node(parent: nodes["1.1.2"]!, state: thirdActionStates[1]), forKey: "1.1.2.2")
        nodes.updateValue(Node(parent: nodes["1.1.2"]!, state: thirdActionStates[2]), forKey: "1.1.2.3")
        nodes.updateValue(Node(parent: nodes["1.1.2.3"]!, state: fourthActionStates[0]), forKey: "1.1.2.3.1")
        nodes.updateValue(Node(parent: nodes["1.1.2.3"]!, state: fourthActionStates[1]), forKey: "1.1.2.3.2")
        
        // Pop, should give us root, then add root children
        var search = MockSearch(frontier: frontier, nodesToConsider: nodes)
        search.frontier.push(nodes["root"]!)
        XCTAssertEqual(nodes["root"], search.pop())
        search.push(nodes["root"]!.children)
        XCTAssertEqual([nodes["1.1"]!, nodes["1.2"]!], search.frontier.collection)
        
        // Pop, should give us 1.1, then add 1.1 children
        XCTAssertEqual(nodes["1.1"], search.pop())
        search.push(nodes["1.1"]!.children)
        XCTAssertEqual([nodes["1.1.2"]!, nodes["1.1.1"]!, nodes["1.2"]!], search.frontier.collection)
        
        // Pop, should give us 1.1.2, then add 1.1.2 children
        XCTAssertEqual(nodes["1.1.2"], search.pop())
        search.push(nodes["1.1.2"]!.children)
        XCTAssertEqual([nodes["1.1.2.3"]!, nodes["1.1.2.1"]!, nodes["1.1.2.2"]!, nodes["1.1.1"]!, nodes["1.2"]!], search.frontier.collection)
        
        // Pop, should give us 1.1.2.3, then add 1.1.2.3 children
        XCTAssertEqual(nodes["1.1.2.3"], search.pop())
        search.push(nodes["1.1.2.3"]!.children)
        XCTAssertEqual([nodes["1.1.2.3.1"]!, nodes["1.1.2.3.2"]!, nodes["1.1.2.1"]!, nodes["1.1.2.2"]!, nodes["1.1.1"]!, nodes["1.2"]!], search.frontier.collection)
    }
}
