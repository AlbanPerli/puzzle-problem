//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

import XCTest

class StaticStateSearchTests: XCTestCase {
    // Goal state for static tests
    private let easyGoalState = State(matrix:[
        [5,6,1],
        [7,0,2],
        [4,3,8]
    ])
    private let hardGoalState = State(matrix:[
        [0,1,2],
        [3,4,5],
        [6,7,8]
    ])

    private func easySearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [6,3,1],
            [5,0,2],
            [7,4,8]
        ])
        testSearchPerformance(Solver(rootState: rootNodeState, method: method))
    }

    private func hardSearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [7,2,4],
            [5,0,6],
            [8,3,1]
        ])
        testSearchPerformance(Solver(rootState: rootNodeState, method: method))
    }

    // MARK: Static easy earch

    func testBFS_Easy() {
        let method = BreadthFirstSearch(goalState: hardGoalState)
        easySearch(method)
    }
    func testDFS_Easy() {
        let method = DepthFirstSearch(goalState: hardGoalState)
        easySearch(method)
    }
    func testGBFS_Easy_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testGBFS_Easy_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testGBFS_Easy_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testGBFS_Easy_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testBOGO_Easy() {
        let method = BogosortSearch(goalState: hardGoalState)
        easySearch(method)
    }
    func testIDS_Easy() {
        let method = IterativeDeepeningDepthFirstSearch(goalState: hardGoalState, threshold: 40)
        easySearch(method)
    }
    func testIDAS_Easy_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        easySearch(method)
    }
    func testIDAS_Easy_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        easySearch(method)
    }
    func testIDAS_Easy_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        easySearch(method)
    }
    func testIDAS_Easy_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        easySearch(method)
    }

    // MARK: Static hard search

    func testBFS_Hard() {
        let method = BreadthFirstSearch(goalState: hardGoalState)
        hardSearch(method)
    }
    func testDFS_Hard() {
        let method = DepthFirstSearch(goalState: hardGoalState)
        hardSearch(method)
    }
    func testGBFS_Hard_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testGBFS_Hard_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testGBFS_Hard_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testGBFS_Hard_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testBOGO_Hard() {
        let method = BogosortSearch(goalState: hardGoalState)
        hardSearch(method)
    }
    func testIDS_Hard() {
        let method = IterativeDeepeningDepthFirstSearch(goalState: hardGoalState, threshold: 40)
        hardSearch(method)
    }
    func testIDAS_Hard_MisplacedTilesCount() {
        let heuristic = MisplacedTilesCount(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        hardSearch(method)
    }
    func testIDAS_Hard_ManhattanDistance() {
        let heuristic = ManhattanDistance(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        hardSearch(method)
    }
    func testIDAS_Hard_EuclideanDistance() {
        let heuristic = EuclideanDistance(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        hardSearch(method)
    }
    func testIDAS_Hard_ChebyshevDistance() {
        let heuristic = ChebyshevDistance(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        hardSearch(method)
    }
}