//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           14/04/2016
//

import XCTest

extension XCTestCase {

    ///
    /// Runs a test on the search performance of a specific `Solver`
    /// - Parameter solver: The solver to run performance tests on
    /// - Returns: The goal node, if there is one
    ///
    func testSearchPerformance(solver: Solver) -> Node? {
        var i = 0
        var now = NSDate()
        var goalNode: Node?
        measureBlock {
            goalNode = solver.solve().goalNode
            self.stopMeasuring()

            i += 1
            print("[\(solver.searchMethod.dynamicType.code)] Performance Test \(i)")
            print("  Time:        \(-now.timeIntervalSinceNow)s")
            print("  Traversed:   \(solver.numberOfNodesTraversed) nodes")
            if goalNode != nil {
                print("  Search Cost: \(goalNode!.actionsToThisNode.count) moves")
            } else {
                print("  No solution was found")
            }
            now = NSDate()
        }
        return goalNode
    }

}
