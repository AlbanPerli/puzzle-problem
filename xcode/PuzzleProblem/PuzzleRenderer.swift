 //
//  StateRenderer.swift
//  PuzzleProblem
//
//  Created by Alex on 2/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

class PuzzleRenderer {
    ///
    /// Number of times node was changed/traversed
    ///
    var timesNodeWasChanged: Int = 0

    ///
    /// Current node to render
    ///
    var node: Node {
        didSet {
            if !self.isSolved {
                self.timesNodeWasChanged += 1
            }
            self.window.title = "PC \(node.pathCost) - #\(self.timesNodeWasChanged)\(self.isSolved ? " (!)" : "")"
            updateTiles()
        }
    }

    ///
    /// Sequence of tiles in the node
    ///
    var sequence: [Int] {
        return self.node.state.sequence
    }

    ///
    /// Whether or not the puzzle is solved
    ///
    var isSolved: Bool = false
    
    ///
    /// Window for renderer
    ///
    let window: XWindow
    
    ///
    /// Dictionary of tiles I know of bound to their value
    ///
    var tiles: Dictionary<Int, TileRenderer> = [:]
    
    ///
    /// Initialises the renderer with a node
    ///
    init(node: Node) {
        let widthOfWindow = UInt(node.state.width) * kSizeOfTile
        let heightOfWindow = UInt(node.state.height) * kSizeOfTile
        self.window = XWindow(title: "Node - PC \(node.pathCost)",
                              width: widthOfWindow,
                              height: heightOfWindow)
        self.node = node
    }
    
    ///
    /// Updates tiles to render
    ///
    func updateTiles() {
        self.updateTiles(self.sequence)
    }
    
    ///
    /// Updates specific tiles to render
    /// - Parameter tiles: The tiles to update
    ///
    func updateTiles(tiles: [Int]) {
        for tileValue in tiles {
            let position = node.state.positionOf(tileValue)!
            // Look up if this tile exists
            if let tile = self.tiles[tileValue] {
                // Only move if it has moved
                if tile.position != position {
                    tile.position = position
                    tile.drawIn(self.window)
                }
            } else {
                let tile = TileRenderer(value: tileValue,
                                        position: position,
                                        color: colorForTile(tileValue))
                self.tiles[tileValue] = tile
                tile.drawIn(self.window)
            }
        }
    }
    
    ///
    /// Stalls the program until the renderer is ready to draw
    ///
    func waitUntilReady() {
        self.window.waitUntilReady()
    }
    
    ///
    /// Gets the color for the tile with the given value
    /// - Parameter value: The value to lookup
    /// - Returns: Color associated to that value
    ///
    private func colorForTile(value: Int) -> Color {
        if value == kEmptyTile {
            return Color.white
        } else {
            var color: Color
            repeat {
                color = Color.random()
            } while color == Color.black || color == Color.white
            return color
        }
    }
}
