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
    private var window: XWindow?
  
    override func tearDown() {
        if let window = self.window {
            // User has requested quit?
            var hasQuit: Bool = false
            // Main loop
            repeat {
                // Keep grabbing the next event as it comes
                switch window.nextEvent {
                // When exposing the window, refresh context
                case Expose:
                    window.flush()
                // Window close requested
                case KeyPress, ClientMessage:
                    hasQuit = true
                // Don't handle
                default:
                    break
                }
            } while !hasQuit
        }
    }

    func testDrawState() {
        let state = State(matrix: [
            [1,2,3],
            [4,0,5],
            [6,7,8]
        ])
        let node = Node(initialState: state)
        let renderer = PuzzleRenderer(node: node)
        renderer.drawAllTiles()
        window = renderer.window
    }

}
