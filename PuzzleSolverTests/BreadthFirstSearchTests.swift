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
            [6,7,4],
            [1,5,3],
            [8,0,2],
        ])
        let rootNode = Node(initialState: rootNodeState)
        let goalState = State(matrix: [
            [0,1,2],
            [3,4,5],
            [6,7,8],
        ])
        let bfs = BreadthFirstSearch(goalState: goalState)
        XCTAssert(bfs.traverse(rootNode)?.count == 2)
    }
}