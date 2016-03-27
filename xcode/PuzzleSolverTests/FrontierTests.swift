//
//  FrontierTests.swift
//  PuzzleProblem
//
//  Created by Alex on 26/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class FrontierTests: XCTestCase {
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
}
