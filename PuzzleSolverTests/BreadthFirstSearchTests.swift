//
//  TestBreadthFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class BreadthFirstSearchTests: XCTestCase {
    func testFourChildNodes() {
        // Set up a multidirectional node
        let rootNodeState = State(matrix: [
            [1,2,3,4,5,0],
            [1,3,4,3,2,1]
        ])
        let rootNode = Node(initialState: rootNodeState)
        let goalState = State(matrix: [
            [0,2,3,4,5,4],
            [1,3,4,3,2,1]
        ])
        let bfs = BreadthFirstSearch(goalState: goalState)
        bfs.traverse(rootNode)
    }
}