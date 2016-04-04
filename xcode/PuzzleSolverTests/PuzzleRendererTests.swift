//
//  GuiTests.swift
//  PuzzleProblem
//
//  Created by Alex on 2/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest
import CX11.Xlib
import CX11.X

class GuiTests: XCTestCase, SearchMethodSubscriber {
    private var renderer: PuzzleRenderer?
    
    func startSubscribing() {
        SearchMethodObserver.sharedObserver.subscribers.append(self)
    }
    
    func didTraverseNode(node: Node, isSolved: Bool) {
        self.renderer!.node = node
    }
    
    func loop(onKeyDown: (WindowEvent)->()) {
        // User has requested quit?
        var hasQuit: Bool = false
        // Main loop
        repeat {
            let event = renderer!.window.nextEvent
            // Keep grabbing the next event as it comes
            switch event.type {
            // When exposing the window, refresh context
            case Expose:
                renderer!.window.flush()
            // Window close requested
            case KeyPress:
                onKeyDown(event)
            case ClientMessage:
                hasQuit = true
            // Don't handle
            default:
                break
            }
        } while !hasQuit
    }

    func testDrawNode() {
        let state = State(matrix: [
            [0,8,9,1,4],
            [6,5,7,3,2]
        ])
        let node = Node(initialState: state)
        renderer = PuzzleRenderer(node: node)
        renderer?.waitUntilReady()
        renderer?.updateTiles()
        loop { event in
            let state = randomState(width: 4)
            let node = Node(initialState: state)
            self.renderer!.node = node
        }
    }
    
    func testDrawWhileSolving() {
        let state = State(matrix: [
            [3,4,1],
            [6,0,2],
            [5,7,8]
        ])
        let goal = State(matrix: [
            [0,1,2],
            [3,4,5],
            [6,7,8]
        ])
        let node = Node(initialState: state)
        renderer = PuzzleRenderer(node: node)
        renderer?.waitUntilReady()
        renderer?.updateTiles()
        startSubscribing()
        AStarSearch(goalState: goal, heuristicFunction: MisplacedTileHeuristic(goalState: goal)).traverse(node)
        loop { event in
            // N/A
        }
    }
    
    func testDrawSolutionOnly() {
        let state = State(matrix: [
            [3,4,1],
            [6,0,2],
            [5,7,8]
        ])
        let goal = State(matrix: [
            [0,1,2],
            [3,4,5],
            [6,7,8]
        ])
        let node = Node(initialState: state)
        // Needs to be reverse to get from start -> end not end -> start
        let nodes: [Node] = (AStarSearch(goalState: goal, heuristicFunction: MisplacedTileHeuristic(goalState: goal)).traverse(node)?.ansecstors.reverse())!
        renderer = PuzzleRenderer(node: node)
        renderer!.waitUntilReady()
        var index = 0
        renderer!.node = nodes[index]
        loop { event in
            var delta = 0
            if self.renderer!.window.didPressKey("f") {
                delta = +1
            }
            else if self.renderer!.window.didPressKey("b") {
                delta = -1
            }
            if delta != 0 && !(index + delta > (nodes.count - 1) || index + delta < 0) {
                index = index + delta
                self.renderer!.node = nodes[index]
            }
        }
    }

}