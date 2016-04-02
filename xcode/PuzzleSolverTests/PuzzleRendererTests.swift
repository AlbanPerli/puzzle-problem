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

class GuiTests: XCTestCase {
    private var renderer: PuzzleRenderer?
    
    func loop(onKeyDown: ()->()) {
        // User has requested quit?
        var hasQuit: Bool = false
        // Main loop
        repeat {
            // Keep grabbing the next event as it comes
            switch renderer!.window.nextEvent {
            // When exposing the window, refresh context
            case Expose:
                renderer!.window.flush()
            // Window close requested
            case KeyPress:
                onKeyDown()
            case ClientMessage:
                hasQuit = true
            // Don't handle
            default:
                break
            }
        } while !hasQuit
    }

    func testDrawNode() {
        let state = randomState(width: 4)
        let node = Node(initialState: state)
        renderer = PuzzleRenderer(node: node)
        while renderer!.window.nextEvent != MapNotify {}
        renderer?.updateTiles()
        loop {
            let state = randomState(width: 4)
            let node = Node(initialState: state)
            self.renderer!.node = node
        }
    }
    
    func testBFSDraw() {
        let state = State(matrix: [
            [0,8,9,1,4],
            [6,5,7,3,2]
        ])
        let goal = State(matrix: [
            [0,1,2,3,4],
            [5,6,7,8,9]
        ])
        let node = Node(initialState: state)
        var method = BreadthFirstSearch(goalState: goal)
        method.traverse(node)
        var traversed = method.nodesTraversed
        renderer = PuzzleRenderer(node: node)
        while renderer!.window.nextEvent != MapNotify {}
        renderer?.updateTiles()
        loop {
            self.renderer!.node = traversed.removeFirst()
        }
    }

}
