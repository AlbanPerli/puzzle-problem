
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

import XCTest
import Foundation

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
    private let randomGoalState =  State(matrix:[
        [0,1,2],
        [3,4,5],
        [6,7,8]
    ]) /*State(matrix:[
        [0 ,1 ,2 ,3 ,4 ],
        [5 ,6 ,7 ,8 ,9 ],
        [10,11,12,13,14],
        [15,16,17,18,19],
        [20,21,22,23,24]
    ])*/

    private func doSearch(solver: Solver) {
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
        XCTAssertNotNil(goalNode)
    }


    private func easySearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [6,3,1],
            [5,0,2],
            [7,4,8]
        ])
        doSearch(Solver(rootState: rootNodeState, method: method))
    }

    private func hardSearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [7,2,4],
            [5,0,6],
            [8,3,1]
        ])
        doSearch(Solver(rootState: rootNodeState, method: method))
    }

    private func randomSearch(method: SearchMethod) {
        let rootNodeState = randomState(3)
        print("Root state generated: ")
        print(rootNodeState.matrix.debugDescription)
        doSearch(Solver(rootState: rootNodeState, method: method))
    }

    // MARK: Dynamic random state search

    func testBFS_Random() {
        let method = BreadthFirstSearch(goalState: randomGoalState)
        randomSearch(method)
    }
    func testDFS_Random() {
        let method = DepthFirstSearch(goalState: randomGoalState)
        randomSearch(method)
    }
    func testGBFS_Random_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: randomGoalState)
        let method = GreedyBestFirstSearch(goalState: randomGoalState, heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testGBFS_Random_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: randomGoalState)
        let method = GreedyBestFirstSearch(goalState: randomGoalState, heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: randomGoalState)
        let method = AStarSearch(goalState: randomGoalState, heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: randomGoalState)
        let method = AStarSearch(goalState: randomGoalState, heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testBOGO_Random() {
        let method = BogosortSearch(goalState: randomGoalState)
        randomSearch(method)
    }
    func testDLS_Random() {
        let method = DepthLimitedSearch(goalState: randomGoalState, threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: randomGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: randomGoalState, heuristicFunction: heuristic, threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: randomGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: randomGoalState, heuristicFunction: heuristic, threshold: 40)
        randomSearch(method)
    }

    // MARK: Static easy earch

    func testBFS_Easy() {
        let method = BreadthFirstSearch(goalState: easyGoalState)
        easySearch(method)
    }
    func testDFS_Easy() {
        let method = DepthFirstSearch(goalState: easyGoalState)
        easySearch(method)
    }
    func testGBFS_Easy_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: easyGoalState)
        let method = GreedyBestFirstSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testGBFS_Easy_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: easyGoalState)
        let method = GreedyBestFirstSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: easyGoalState)
        let method = AStarSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: easyGoalState)
        let method = AStarSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testBOGO_Easy() {
        let method = BogosortSearch(goalState: easyGoalState)
        easySearch(method)
    }
    func testDLS_Easy() {
        let method = DepthLimitedSearch(goalState: easyGoalState, threshold: 40)
        easySearch(method)
    }
    func testIDAS_Easy_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: easyGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: easyGoalState, heuristicFunction: heuristic, threshold: 40)
        easySearch(method)
    }
    func testIDAS_Easy_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: easyGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: easyGoalState, heuristicFunction: heuristic, threshold: 40)
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
    func testGBFS_Hard_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testGBFS_Hard_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testBOGO_Hard() {
        let method = BogosortSearch(goalState: hardGoalState)
        hardSearch(method)
    }
    func testDLS_Hard() {
        let method = DepthLimitedSearch(goalState: hardGoalState, threshold: 40)
        hardSearch(method)
    }
    func testIDAS_Hard_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        hardSearch(method)
    }
    func testIDAS_Hard_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: hardGoalState)
        let method = IterativeDeepeningAStarSearch(goalState: hardGoalState, heuristicFunction: heuristic, threshold: 40)
        hardSearch(method)
    }
}