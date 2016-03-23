//
//  TestBreadthFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class StaticStateSearchTests: XCTestCase {
    // Goal state for static tests
    private let goalState = State(matrix: [
        [0,1,2],
        [3,4,5],
        [6,7,8]
    ])

    private func search(method: SearchMethod) {
        // Set up a multidirectional node
        let rootNodeState = State(matrix: [
            [3,4,1],
            [6,0,2],
            [5,7,8]
        ])
        let rootNode = Node(initialState: rootNodeState)

        XCTestCase.defaultPerformanceMetrics()

        let expectedActions: [Action] = [
            Action(movingPosition: (1,1), inDirection: .Up),
            Action(movingPosition: (0,1), inDirection: .Right),
            Action(movingPosition: (0,2), inDirection: .Down),
            Action(movingPosition: (1,2), inDirection: .Down),
            Action(movingPosition: (2,2), inDirection: .Left),
            Action(movingPosition: (2,1), inDirection: .Left),
            Action(movingPosition: (2,0), inDirection: .Up),
            Action(movingPosition: (1,0), inDirection: .Right),
            Action(movingPosition: (1,1), inDirection: .Down),
            Action(movingPosition: (2,1), inDirection: .Right),
            Action(movingPosition: (2,2), inDirection: .Up),
            Action(movingPosition: (1,2), inDirection: .Left),
            Action(movingPosition: (1,1), inDirection: .Left),
            Action(movingPosition: (1,0), inDirection: .Up)
        ]

        var actions: [Action] = []

        measureBlock {
            actions = method.traverse(rootNode)!
        }

        XCTAssert(actions.count == expectedActions.count)
        XCTAssert(actions == expectedActions)
    }
    func testBFS() {
        let method = BreadthFirstSearch(goalState: self.goalState)
        search(method)
    }
    func testDFS() {
        let method = DepthFirstSearch(goalState: self.goalState)
        search(method)
    }
}