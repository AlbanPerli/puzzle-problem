//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           14/04/2016
//


import XCTest
import Foundation

class RandomStateSearchTests: XCTestCase {
    private static var states: (start: State, goal: State) = {
        let env = NSProcessInfo.processInfo().environment
        let envWidth  = env["RANDOM_STATE_WIDTH" ] ?? ""
        let envHeight = env["RANDOM_STATE_HEIGHT"] ?? ""
        // Use env vars if provided, else randomise dimensions from 1 to 5
        let dimensions = (
            width:  Int(envWidth ) ?? Int(cs_arc4random_uniform(4) + 1),
            height: Int(envHeight) ?? Int(cs_arc4random_uniform(4) + 1)
        )
        let startState = randomState(dimensions.width, cols: dimensions.height)
        let goalState =  randomState(dimensions.width, cols: dimensions.height)
        print("Dimensions:")
        print("\(dimensions.width)x\(dimensions.height)")
        print("Start state:")
        print(startState.matrix.debugDescription)
        print("Goal state:")
        print(goalState.matrix.debugDescription)
        return (start: startState, goal: goalState)
    }()
    
    private let startState = RandomStateSearchTests.states.start
    private let goalState  = RandomStateSearchTests.states.goal
    
    private func randomSearch(method: SearchMethod) {
        let solver = Solver(rootState: startState, method: method)
        testSearchPerformance(solver)
    }
    
    // MARK: Dynamic random state search
    
    func testBFS_Random() {
        let method = BreadthFirstSearch(goalState: goalState)
        randomSearch(method)
    }
    func testDFS_Random() {
        let method = DepthFirstSearch(goalState: goalState)
        randomSearch(method)
    }
    func testGBFS_Random_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: goalState)
        let method = GreedyBestFirstSearch(goalState: goalState,
                                           heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testGBFS_Random_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: goalState)
        let method = GreedyBestFirstSearch(goalState: goalState,
                                           heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testGBFS_Random_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: goalState)
        let method = GreedyBestFirstSearch(goalState: goalState,
                                           heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testGBFS_Random_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: goalState)
        let method = GreedyBestFirstSearch(goalState: goalState,
                                           heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: goalState)
        let method = AStarSearch(goalState: goalState,
                                 heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: goalState)
        let method = AStarSearch(goalState: goalState,
                                 heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: goalState)
        let method = AStarSearch(goalState: goalState,
                                 heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: goalState)
        let method = AStarSearch(goalState: goalState,
                                 heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testBOGO_Random() {
        let method = BogosortSearch(goalState: goalState)
        randomSearch(method)
    }
    func testDLS_Random() {
        let method = DepthLimitedSearch(goalState: goalState, threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: goalState)
        let method = IterativeDeepeningAStarSearch(goalState: goalState,
                                                   heuristicFunction: heuristic,
                                                   threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: goalState)
        let method = IterativeDeepeningAStarSearch(goalState: goalState,
                                                   heuristicFunction: heuristic,
                                                   threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: goalState)
        let method = IterativeDeepeningAStarSearch(goalState: goalState,
                                                   heuristicFunction: heuristic,
                                                   threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: goalState)
        let method = IterativeDeepeningAStarSearch(goalState: goalState,
                                                   heuristicFunction: heuristic,
                                                   threshold: 40)
        randomSearch(method)
    }
}