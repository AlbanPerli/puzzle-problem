//
//  COS30019 Introduction to AI
//  Assignment 1
//
//  Alex Cummuado 1744070
//

///
/// A direction for `up`, `down`, `left`, and `right`
///
enum Direction {
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
}
