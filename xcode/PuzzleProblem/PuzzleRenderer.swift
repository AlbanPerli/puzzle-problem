//
//  StateRenderer.swift
//  PuzzleProblem
//
//  Created by Alex on 2/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct PuzzleRenderer {   
    ///
    /// Current state to render
    ///
    var state: State {
        didSet {
            drawAllTiles()
        }
    }
    
    ///
    /// Window for renderer
    ///
    let window: XWindow
    
    ///
    /// Initialises the renderer with a node
    ///
    init(node: Node) {
        let widthOfWindow = UInt(node.state.width) * kSizeOfTile
        let heightOfWindow = UInt(node.state.height) * kSizeOfTile
        self.window = XWindow(title: "Node - PC \(node.pathCost)",
                              width: widthOfWindow,
                              height: heightOfWindow)
        self.state = node.state
    }
    
    ///
    /// Draws all tiles in the current state
    ///
    func drawAllTiles() {
        // Draw tiles in the state
        for tileValue in state.sequence {
            let position = state.positionOf(tileValue)
            self.drawTile(tileValue, position: position!)
        }
    }
    
    ///
    /// Draws a single tile at a given position
    /// - Parameter value: Value displayed on the tile
    /// - Parameter position: Position of the tile
    ///
    private func drawTile(value: Int, position: Position) {
        var color: Color
        if value == kEmptyTile {
            color = Color.white
        } else {
            repeat {
                color = Color.random()
            } while color == Color.black || color == Color.white
        }
        let tile = TileRenderer(value: value, position: position, color: color)
        tile.drawIn(self.window)
    }
}
