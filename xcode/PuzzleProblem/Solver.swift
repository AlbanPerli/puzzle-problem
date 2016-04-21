//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

import CX11.Xlib
import CX11.X

///
/// Solver for a Puzzle Problem
///
class Solver: SearchMethodObserver {
    ///
    /// The root node of the puzzle
    ///
    private let rootNode: Node
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
    /// Optional original filename that parsed this puzzle
    ///
    private let filename: String?
    ///
    /// Number of nodes traversed
    ///
    private(set) var numberOfNodesTraversed: Int = 0
    ///
    /// The goal node that solved the puzzle
    ///
    private(set) var goalNode: Node?
    ///
    /// The search method used to solve the puzzle
    ///
    var searchMethod: SearchMethod

    ///
    /// Initialises a Puzzle Solver with the root node and search method to use
    /// - Parameter filename: Original filename used to parse input
    /// - Parameter node: The root node
    /// - Parameter method: The search method
    /// - Parameter gui: Whether or not to display a GUI and the type of GUI to use
    ///
    init(rootNode: Node, method: SearchMethod, gui: Launcher.GUIType? = nil, filename: String? = nil) {
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
    /// Initialises a Puzzle Solver with the root node and search method to use
    /// - Parameter filename: Original filename used to parse input
    /// - Parameter state: The root state
    /// - Parameter method: The search method
    /// - Parameter gui: Whether or not to display a GUI and the type of GUI to use
    ///
    convenience init(rootState: State, method: SearchMethod, gui: Launcher.GUIType? = nil, filename: String? = nil) {
        let rootNode = Node(initialState: rootState)
        self.init(rootNode: rootNode,
                  method: method,
                  gui: gui,
                  filename: filename)
    }

    ///
    /// Sets up the renderer for display
    ///
    private func setUpRenderer() {
        self.renderer = PuzzleRenderer(node: rootNode)
        self.renderer!.waitUntilReady().render()
    }
    
    ///
    /// Solves the puzzle
    /// - Returns: `self` to support chaining
    ///
    func solve() -> Solver {
        // Register for observation notifications to count how many nodes
        // have been traversed and for GUI events if gui == .Solving
        SearchMethodObservationCenter.sharedCenter.addObserver(self)
        // Reset from previous solve
        self.numberOfNodesTraversed = 0
        // Meant to show puzzle solving?
        if self.isShowingPuzzleSolving && (self.renderer == nil) {
            self.setUpRenderer()
        }
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
        let headerStrings = [
            // File name or N/A
            (self.filename ?? "N/A"),
            // Search code
            self.searchMethod.dynamicType.code,
            // Number of nodes traversed
            String(self.numberOfNodesTraversed)
        ]
        print(headerStrings.joinWithSeparator("\t"))
        // Get the header string
        let resultStr =
            self.goalNode?
                .actionsToThisNode
                .map({ $0.direction.description })
                .joinWithSeparator(";")
            ?? "No solution found."
        print(resultStr)
        
        // GUI
        guard
            let goalNode = self.goalNode,
            let renderer = self.renderer
        else {
            // Nothing to display
            return
        }
        
        if !self.isShowingPuzzleSolving {
            print("Showing solution in GUI...")
        }
        print("> Press [B] or [↑] to go up the tree by one node")
        print("> Press [F] or [↓] to go down the tree by one node")
        print("> Press [Q] to quit")
    
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
            if renderer.window.didPressKey("f") || renderer.window.didPressKey("Down") {
                delta = +1
            }
            else if renderer.window.didPressKey("b") || renderer.window.didPressKey("Up") {
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
                if (self.renderer == nil) {
                    self.setUpRenderer()
                    // Update number of times node was changed if it hasn't been
                    // updated yet
                    self.renderer!.timesNodeWasChanged = self.numberOfNodesTraversed
                    self.renderer!.isSolved = true
                }
            }
            // Only update the renderer's node if showing puzzle solving
            if let renderer = self.renderer where self.isShowingPuzzleSolving {
                renderer.node = node
            }
        }
    }
}
