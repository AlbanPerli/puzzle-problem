//
//  Problem.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import CX11.Xlib
import CX11.X

///
/// Solver for a Puzzle Problem
///
class Solver: SearchMethodSubscriber {
    ///
    /// The root node of the puzzle
    ///
    private let rootNode: Node
    ///
    /// The search method used to solve the puzzle
    ///
    private let searchMethod: SearchMethod
    ///
    /// A GUI renderer to display solving the puzzle
    ///
    private var renderer: PuzzleRenderer?
    ///
    /// Whether or not to show the GUI solving puzzle states
    ///
    private let isShowingPuzzleSolving: Bool
    ///
    /// Whether or not a GUI is to be shown
    ///
    private let isShowingGUI: Bool
    ///
    /// Original filename that parsed this puzzle
    ///
    let filename: String
    ///
    /// Number of nodes traversed
    ///
    var numberOfNodesTraversed: Int = 0
    ///
    /// The goal node that solved the puzzle
    ///
    var goalNode: Node?
    ///
    /// Initialises a Puzzle Solver with the root node and search method to use
    /// - Parameter filename: Original filename used to parse input
    /// - Parameter node: The root node
    /// - Parameter method: The search method
    /// - Parameter gui: Whether or not to display a GUI and the type of GUI to use
    ///
    init(filename: String, rootNode: Node, method: SearchMethod, gui: Launcher.GUIType? = nil) {
        self.rootNode = rootNode
        self.searchMethod = method
        self.filename = filename
        // Intialise renderer when need be
        self.renderer = nil
        if let gui = gui {
            self.isShowingGUI = true
            self.isShowingPuzzleSolving = gui == .Solving
        } else {
            self.isShowingPuzzleSolving = false
            self.isShowingGUI = false
        }
    }
    
    ///
    /// Sets up the renderer for display
    ///
    private func setUpRenderer() {
        guard let renderer = self.renderer else {
            fatalError("Cannot set up renderer if renderer is uninitialised")
        }
        renderer.waitUntilReady().render()
    }
    
    ///
    /// Solves the puzzle
    /// - Returns: `self` to support chaining
    ///
    func solve() -> Solver {
        // Register for observation notifications to count how many nodes
        // have been traversed and for GUI events if gui == .Solving
        SearchMethodObserver.sharedObserver.subscribers.append(self)
        // Meant to show puzzle solving?
        if self.isShowingPuzzleSolving && (self.renderer == nil) {
            self.renderer = PuzzleRenderer(node: rootNode)
            self.setUpRenderer()
        }
        // Reset from previous solve
        numberOfNodesTraversed = 0
        goalNode = nil
        // Try to solve
        self.goalNode = self.searchMethod.traverse(self.rootNode)
        // Support chaining
        return self
    }
    
    ///
    /// Main loop for GUI
    ///
    private func guiLoop(onKeyDownBlock: (event: WindowEvent, inout hasQuit: Bool) ->()) {
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
                onKeyDownBlock(event: event, hasQuit: &hasQuit)
            case ClientMessage:
                hasQuit = true
            // Don't handle
            default:
                break
            }
        } while !hasQuit
        // Deinit renderer
        self.renderer = nil
    }
    
    
    ///
    /// Displays the results and the GUI is present
    ///
    func displayResults() {
        // Print out
        print("\(self.filename)\t\(self.searchMethod.dynamicType.code)\t\(self.numberOfNodesTraversed)")
        let resultStr = self.goalNode?.actionsToThisNode.map({ $0.description }).joinWithSeparator("; ") ?? "No solution found."
        print(resultStr)
        
        // GUI
        guard
            let goalNode = self.goalNode,
            let renderer = self.renderer
        else {
            // Nothing to display
            return
        }
    
        // Nodes to display
        let nodes: [Node] = goalNode.ansecstors.reverse()
        var index = nodes.count - 1
        renderer.node = nodes[index]

        // Run the main GUI loop
        self.guiLoop { (event: WindowEvent, inout hasQuit: Bool) in
            var delta = 0
            if renderer.window.didPressKey("Escape") || renderer.window.didPressKey("q") {
                hasQuit = true
            }
            if renderer.window.didPressKey("f") {
                delta = +1
            }
            else if renderer.window.didPressKey("b") {
                delta = -1
            }
            if delta != 0 && !(index + delta > (nodes.count - 1) || index + delta < 0) {
                index = index + delta
                renderer.node = nodes[index]
            }
        }
        
    }
    
    // MARK: Implement SearchMethodSubscriber
    func didTraverseNode(node: Node, isSolved: Bool) {
        numberOfNodesTraversed += 1
        // Draw changes if gui is present
        if isShowingGUI {
            // Check if
            if isSolved {
                // Create renderer now if not yet created
                self.renderer?.isSolved = true
            }
            // Only update the renderer's node if showing puzzle solving
            if let renderer = self.renderer where self.isShowingPuzzleSolving {
                renderer.node = node
            }
        }
    }
}
