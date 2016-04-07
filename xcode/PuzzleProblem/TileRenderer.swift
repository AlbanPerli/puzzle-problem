//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           2/04/2016
//

///
/// Constant that defines the size of a tile, in pixels
///
let kSizeOfTile: UInt = 75

///
/// Renders a tile
///
class TileRenderer {
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
    private var onScreenPosition: (x: Int, y: Int)
    
    ///
    /// Tile position
    ///
    var position: Position {
        didSet {
            let xPos = position.col * Int(kSizeOfTile)
            let yPos = position.row * Int(kSizeOfTile)
            self.onScreenPosition = (xPos, yPos)
        }
    }
    
    ///
    /// Initialises a drawable tile
    /// - Parameter value: The value to display on the tile
    /// - Parameter position: The position of the tile in the state
    /// - Parameter color: The color of the tile
    ///
    init(value: Int, position: Position, color: Color) {
        self.value = value
        self.color = color
        self.position = position
        let xPos = position.col * Int(kSizeOfTile)
        let yPos = position.row * Int(kSizeOfTile)
        self.onScreenPosition = (xPos, yPos)
    }
    
    ///
    /// Draws the tile into the specified window
    /// - Parameter window: The window to draw to
    ///
    func drawIn(window: XWindow) {
        let size = (kSizeOfTile, kSizeOfTile)
        let sizeOfOutline = (kSizeOfTile - 1, kSizeOfTile - 1)
        let rectangle = Rectangle(color: color,
                                  filled: true,
                                  position: onScreenPosition,
                                  size: size)
        let rectangleOutline = Rectangle(color: Color.black,
                                         filled: false,
                                         position: onScreenPosition,
                                         size: sizeOfOutline)
        window.drawShape(rectangle)
        window.drawShape(rectangleOutline)
        
        let positionOfText = (
            x: self.onScreenPosition.x + 5 + Int(kSizeOfTile / 2),
            y: self.onScreenPosition.y + 5 + Int(kSizeOfTile / 2)
        )
        
        // Dark color?
        var textColor: Color
        if self.color == Color.blue {
            textColor = Color.white
        } else {
            textColor = Color.black
        }
        
        window.drawText(String(self.value), position: positionOfText, color: textColor)
        window.flush()
    }
}
