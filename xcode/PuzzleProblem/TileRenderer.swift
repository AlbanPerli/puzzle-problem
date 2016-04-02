//
//  TileRenderer.swift
//  PuzzleProblem
//
//  Created by Alex on 2/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Constant that defines the size of a tile, in pixels
///
let kSizeOfTile: UInt = 75

///
/// Renders a tile
///
struct TileRenderer {
    ///
    /// The color to draw
    ///
    private let color: Color
    
    ///
    /// The value of the tile
    ///
    private let value: Int
    
    ///
    /// The position of the tile on screen
    ///
    private let position: (x: Int, y: Int)
    
    ///
    /// Initialises a drawable tile
    /// - Parameter value: The value to display on the tile
    /// - Parameter position: The position of the tile in the state
    /// - Parameter color: The color of the tile
    ///
    init(value: Int, position: Position, color: Color) {
        self.value = value
        self.color = color
        
        let xPos = position.row * Int(kSizeOfTile)
        let yPos = position.col * Int(kSizeOfTile)
        self.position = (xPos, yPos)
    }
    
    ///
    /// Draws the tile into the specified window
    /// - Parameter window: The window to draw to
    ///
    func drawIn(window: XWindow) {
        let size = (kSizeOfTile, kSizeOfTile)
        let rectangle = Rectangle(color: color,
                                  filled: true,
                                  position: position,
                                  size: size)
        let rectangleOutline = Rectangle(color: Color.black,
                                         filled: false,
                                         position: position,
                                         size: size)
        window.drawShape(rectangle)
        window.drawShape(rectangleOutline)
        
        let positionOfText = (
            x: self.position.x + 5 + Int(kSizeOfTile / 2),
            y: self.position.y + 5 + Int(kSizeOfTile / 2)
        )
        
        // Dark color?
        var textColor: Color
        if self.color == Color.blue {
            textColor = Color.white
        } else {
            textColor = Color.black
        }
        
        window.drawText(String(self.value), position: positionOfText, color: textColor)
    }
}
