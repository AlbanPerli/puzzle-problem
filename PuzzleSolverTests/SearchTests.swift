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
    private let goalState = State(matrix:[
        [0,1,2],
        [3,4,5],
        [6,7,8]
    ])

    private func doSearch(method: SearchMethod, rootNodeState: State, expectedActions: [Action]) {
        let rootNode = Node(initialState: rootNodeState)
        var node = rootNodeState
        for a in expectedActions {
            node = node.performAction(a)!
            print(node)
        }
        var actions: [Action]? = []
        measureBlock {
            actions = method.traverse(rootNode)
        }
        XCTAssert(actions?.count == expectedActions.count)
        XCTAssert(actions! == expectedActions)
    }


    private func easySearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [6,3,1],
            [5,0,2],
            [7,4,8]
        ])
        let expectedActions = [
            Action(movingPosition: (1,1), inDirection: .Up),
            Action(movingPosition: (0,1), inDirection: .Left),
            Action(movingPosition: (0,0), inDirection: .Down),
            Action(movingPosition: (1,0), inDirection: .Down),
            Action(movingPosition: (2,0), inDirection: .Left),
            Action(movingPosition: (2,1), inDirection: .Up),
            Action(movingPosition: (1,1), inDirection: .Down)
        ]
        doSearch(method, rootNodeState: rootNodeState, expectedActions: expectedActions)
    }

    private func hardSearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [3,4,1],
            [6,0,2],
            [5,7,8]
        ])
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
        doSearch(method, rootNodeState: rootNodeState, expectedActions: expectedActions)
    }

    func testBFSEasy() {
        let method = BreadthFirstSearch(goalState: goalState)
        easySearch(method)
    }
    func testDFSEasy() {
        let method = DepthFirstSearch(goalState: goalState)
        easySearch(method)
    }
    func testBFSHard() {
        let method = BreadthFirstSearch(goalState: goalState)
        hardSearch(method)
    }
    func testDFSHard() {
        let method = DepthFirstSearch(goalState: goalState)
        hardSearch(method)
    }
}