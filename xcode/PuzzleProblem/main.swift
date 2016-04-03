//
//  main.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Launcher for the solver
///
struct Launcher {
    // MARK: Singleton
    static let sharedLauncher = Launcher()
    
    // MARK: Launch Errors
    
    ///
    /// Errors that can be caused on launch
    ///
    enum LaunchError: ErrorType {
        case NotEnoughArgumentsProvided
        case InvalidMethodProvided
        case InvalidHeuristicSpecified
        case ProvidedHeuristicToUninformed
        case InvalidCutoffSpecified
        case FileUnreadable
        case NoSizeLine
        case NoDataLines
        case UnexpectedCharacterInDataLine
        case DataLineSizeMismatch
        case CutoffNotAllowed
        
        ///
        /// Textual description of each error
        ///
        var message: String {
            switch self {
            case .NotEnoughArgumentsProvided:
                return "Invalid arguments. Use `help` for more info."
            case .InvalidMethodProvided:
                return "Invalid search method provided. Use `help` for more info."
            case .FileUnreadable:
                return "File provided was unreadable"
            case .NoDataLines:
                return "Not enough data lines in file. Expects at least one after size line"
            case .NoSizeLine:
                return "Size line was missing or invalid. Expects first line to be in format NxM"
            case .UnexpectedCharacterInDataLine:
                return "Unexpected character in data line. Expects data line to be in format n n n n..."
            case .DataLineSizeMismatch:
                return "Expects data line size to match size of N*M"
            case .InvalidCutoffSpecified:
                return "Cutoff value specified should be a numerical value greater than 2"
            case .CutoffNotAllowed:
                return "You can only specify a cut off using a Depth Limited Search"
            case .InvalidHeuristicSpecified:
                return "Heuristic should be one of `misplaced` or `distance`"
            case .ProvidedHeuristicToUninformed:
                return "You can only provide a heuristic to an informed search"
            }
        }
    }
    
    // MARK: GUI Type
    
    ///
    /// Acceptable arguments for GUI switch
    ///
    enum GUIType: String {
        case Solution
        case Solving
    }
    
    // MARK: Heuristics
    enum HeuristicType: String {
        case MisplacedTile
        case DistanceToGoal
    }
    
    // MARK: Help descriptions

    ///
    /// The help text
    ///
    var helpText: String {
        let str = [
            "Usage:",
            "  search file method [ OPTIONS ]",
            "  search --help",
            "",
            "Puzzle problem search solver",
            "",
            "File:",
            "  Expects a file whose first line describes the size of the root state(s)",
            "  and the lines thereafter contain the shuffled sequence to solve of those",
            "  state(s). Example:",
            "",
            "    3x4",
            "    0 1 2 3 4 5 6 7 8 9 10 11 12",
            "    12 11 10 9 8 7 6 5 4 3 2 1 0",
            "",
            "Method:",
            self.searchMethodDescriptions,
            "",
            "Options:",
            " --gui[=solution|solving]           Invoke the puzzle showing a GUI. Defaults to `solution`",
            "                                    `solution` shows a solution and uses the F and",
            "                                               B keys to traverse through a solution",
            "                                    `solving`  shows the search solving the puzzle (slow)",
            "                                               and then show the output solution",
            " --heuristic=[misplaced|distance]   Invoke the puzzle using a specific heuristic. Defaults to",
            "                                    `distance` when a unformed search method is used. Ignores",
            "                                    whatever value is specified when an uniformed search is used",
            "                                    `distance` uses the Distance To Goal heuristic",
            "                                    `misplaced` uses the Misplaced Tile heuristic",
            " --cutoff=[n]                       Valid to DLS searches for depth cutoff count. When not",
            "                                    specified, n = 10"
        ]
        return str.joinWithSeparator("\n")
    }
    
    ///
    /// Returns textual description of all search methods available
    ///
    var searchMethodDescriptions: String {
        let str = [
            "  Uninformed:",
            "  [BFS]        run search using Breadth First Search",
            "  [DFS]        run search using Depth First Search",
            "  [DLS|UNIF1]  run search using Depth Limited Search. Requires --cutoff parameter",
            "  [BOGO|UINF2] run search using Bogosort Search",
            "",
            "  Informed:",
            "  [GBFS]       run search using Greedy Best First Search",
            "  [AS]         run search using A Star Search",
        ]
        return str.joinWithSeparator("\n")
    }
    
    // MARK: Parsers
    
    ///
    /// Parse the provided `method` and return a search method
    /// - Parameter method: A textual representation of a method's code
    /// - Parameter rootState: The root state to initalise the method with
    /// - Parameter heuristicType: The heuristic type to use if parsing an informed search, ignored otherwise
    /// - Parameter cutoff: The cutoff when parsing a Depth Limited Search, ignored otherwise
    /// - Returns: A new `SearchMethod`, or `nil` if the `method` provided was invalid
    ///
    private func parseMethod(method: String, rootState: State, heuristicType: HeuristicType?, cutoff: Int) throws -> SearchMethod {
        // Generate the goal state from the provided root state
        // Essentially, order the sequence from 1->n with 0 being at the end
        let goalStateSequence = rootState.sequence.sort()
        let goalState = State(sequence: goalStateSequence, height: rootState.height, width: rootState.width)
        let heuristic: HeuristicFunction = heuristicType == .MisplacedTile ?
            MisplacedTileHeuristic(goalState: goalState) :
            DistanceToGoalHeuristic(goalState: goalState)
        
        let testShouldntHaveHeuristic = {
            if heuristicType != nil {
                throw LaunchError.ProvidedHeuristicToUninformed
            }
        }
        // Match the state against the code provided
        switch method.uppercaseString {
        case DepthFirstSearch.code:
            try testShouldntHaveHeuristic()
            return DepthFirstSearch(goalState: goalState)
        case BreadthFirstSearch.code:
            try testShouldntHaveHeuristic()
            return BreadthFirstSearch(goalState: goalState)
        case GreedyBestFirstSearch.code:
            return GreedyBestFirstSearch(goalState: goalState, heuristicFunction: heuristic)
        case AStarSearch.code:
            return AStarSearch(goalState: goalState, heuristicFunction: heuristic)
        case DepthLimitedSearch.code:
            try testShouldntHaveHeuristic()
            return DepthLimitedSearch(goalState: goalState, depthCutoff: cutoff)
        case BogosortSearch.code:
            try testShouldntHaveHeuristic()
            return BogosortSearch(goalState: goalState)
        default:
            throw LaunchError.InvalidMethodProvided
        }
    }
    
    ///
    /// Parse the provided file to return `State`s read from the file
    /// - Parameter path: The path of the file to parse
    /// - Returns: The contents of the file parsed into multiple `State`s, or `nil` if the file
    ///            was invalid
    ///
    private func parseFile(path: String) throws -> [State]? {
        // Read the file
        guard let contents = FileParser.readFile(path) else {
            throw LaunchError.FileUnreadable
        }
        // Support Windows carriage–returns
        let splitBy = Character(contents.characters.contains("\r\n") ? "\r\n" : "\n")
        let lines = contents.characters.split(splitBy)
        let dataLines = lines.suffixFrom(1)
        // Need at least one data line
        if dataLines.count == 0 {
            throw LaunchError.NoDataLines
        }
        guard
            let size = lines.first?.split("x"),
            let width = Int(String(size[0])),
            let height = Int(String(size[1]))
            else {
                throw LaunchError.NoSizeLine
        }
        var result: [State] = []
        for line in dataLines {
            let sequence = line.split(" ").map { Int(String($0)) }
            if sequence.contains({ $0 == nil }) {
                throw LaunchError.UnexpectedCharacterInDataLine
            }
            if sequence.count != height * width {
                throw LaunchError.DataLineSizeMismatch
            }
            result.append(State(sequence: sequence.flatMap { $0 }, height: height, width: width))
        }
        return result
    }
    
    ///
    /// Parses program argumenrts
    /// - Returns: Tuple containing arguments
    ///
    private func parseArgs() throws ->
        (nodes: [Node],
         methods: [SearchMethod],
         gui: GUIType?)? {
        // Strip the args
        var args = Process.arguments.enumerate().generate()
        // Data returned
        var usingGuiType: GUIType?
        // Use misplaced tile by default, otherwise misplaced if provided
        var usingHeuristic: HeuristicType?
        if args.contains({$0.element == "--heuristic=misplaced"}) {
            usingHeuristic = .MisplacedTile
        } else if args.contains({$0.element == "--heuristic=distance"}) {
            usingHeuristic = .DistanceToGoal
        } else if args.contains({$0.element.hasPrefix("--heuristic")}) {
            throw LaunchError.InvalidHeuristicSpecified
        }
        var rootStates: [State] = []
        var methods: [SearchMethod] = []
        // Default cutoff
        var cutoff: Int = 10
        // Check for cutoff
        for arg in args {
            if arg.element.hasPrefix("--cutoff=") {
                // Only allow cuttoff for DLS search
                if Process.arguments[2] != DepthLimitedSearch.code {
                    throw LaunchError.CutoffNotAllowed
                }
                guard let cutoffProvided = Int(String(arg.element.characters.split("=").last)) where cutoff > 2 else {
                    throw LaunchError.InvalidCutoffSpecified
                }
                cutoff = cutoffProvided
                break
            }
        }
        // Look for extra arguments
        while let arg = args.next() {
            // Default to index positions
            switch arg.index {
            // Filename
            case 1:
                // Try parse provided file
                rootStates = try parseFile(arg.element)!
            // Search method
            case 2:
                methods = try rootStates.map { state -> SearchMethod in
                    try parseMethod(arg.element, rootState: state, heuristicType: usingHeuristic, cutoff: cutoff)
                }
            default:
                // Don't handle
                break
            }
            // Look for textual
            switch arg.element {
            case "--help", "-help", "help", "-h":
                return nil
            case "--gui", "--gui=solution":
                usingGuiType = .Solution
            case "--gui=solving":
                usingGuiType = .Solving
            default:
                // Don't handle
                break
            }
        }
        let rootNodes = rootStates.map { Node(initialState: $0) }
        return (rootNodes, methods, usingGuiType)
    }
    
    
    // MARK: Entry point
    
    ///
    /// Entry point of the solver
    ///
    func run() throws {
        do {
            // Process args when argc is at least 2 else print help
            if let args = try parseArgs() where Process.argc > 2 {
                print(args)
            } else {
                print(self.helpText)
            }
        } catch let error as Launcher.LaunchError {
            throw error
        }
    }
}


do {
    try Launcher.sharedLauncher.run()
} catch let error as Launcher.LaunchError {
    print(error.message)
}
