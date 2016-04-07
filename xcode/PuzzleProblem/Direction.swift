//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

///
/// A direction for `up`, `down`, `left`, and `right`
///
enum Direction: String, CustomStringConvertible {
    case Up
    case Down
    case Left
    case Right
    ///
    /// The inverse of the current direction, e.g. `Up`'s inverse is `Down`
    ///
    var inverse: Direction {
        switch self {
        case .Up:
            return .Down
        case .Down:
            return .Up
        case .Left:
            return .Right
        case .Right:
            return .Left
        }
    }
    // MARK: Implement CustomStringConvertible
    var description: String {
        return self.rawValue
    }
}
