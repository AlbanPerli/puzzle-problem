//
//  Action.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// An abstraction of a single `position` moved in a given `direction`
///
struct Action {
    let position: Position
    let direction: Direction

    static func move(position: Position, inDirection dir: Direction) -> Action {
        // How much to move the provided row or column by
        var row = position.row
        var col = position.col

        // Use the directive to determine which element we are looking at
        switch dir {
        case .Up:
            row -= 1
        case .Down:
            row += 1
        case .Left:
            col -= 1
        case .Right:
            col += 1
        }
        
        return Action(movingPosition: (row, col), inDirection: dir.inverse)
    }

    init(movingPosition position: Position, inDirection direction: Direction) {
        self.direction = direction
        self.position = position
    }
}