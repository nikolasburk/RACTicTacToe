
extension Array {
    
    func sliceUp (pieces: Int) -> [[Element]] {
        let sliceLength = self.count % pieces == 0 ? self.count / pieces : self.count / pieces + 1
        var result: [[Element]] = []
        var row: [Element] = []
        var colIndex = 0
        for x in self {
            row.append(x)
            if row.count == sliceLength {
                result.append(row)
                row = []
            }
            colIndex = colIndex == sliceLength-1 ? 0 : colIndex+1
        }
        if row.count > 0 {
            result.append(row)
        }
        return result
    }
}



let a = [0,1,2,3,4,5]
var t = a.sliceUp(3)
let x2 = t.flatMap{$0}
x2

enum Marker: Equatable {
    case Circle
    case Cross
}

enum BoardOrMsg {
    case Board
    case Error(String)
}

func theOtherMarker(marker: Marker) -> Marker {
    if marker == Marker.Circle {
        return Marker.Cross
    }
    else {
        return Marker.Circle
    }
}


enum Field {
    case Empty
    case Marked(Marker)
}

func ==(lhs: Field, rhs: Field) -> Bool {
    switch (lhs, rhs) {
    case (.Empty, .Empty):
        return true
    case (.Marked(let m1), .Marked(let m2)):
        return m1 == m2
    default:
        return false
    }
}
func !=(lhs: Field, rhs: Field) -> Bool {
    return !(lhs == rhs)
}

func allEqual(a: [Field]) -> Bool {
    if let firstElem = a.first {
        return !a.contains { $0 != firstElem }
    }
    return false
}

let f1 = Field.Marked(Marker.Cross)
let f2 = Field.Empty

f1 == Field.Empty
f1 == Field.Marked(Marker.Cross)

let fields = [Field](count: 9, repeatedValue:Field.Empty)

fields.filter {f in f == Field.Empty}.count

typealias Grid = [[Field]]

func fieldsToGrid(fields: [Field]) -> Grid {
    let grid = fields.sliceUp(3)
    return grid
}

struct Board {
    
    // should always contain nine fields
    let grid: Grid
    
    init(fields: [Field]) {
        grid = fieldsToGrid(fields)
    }
}

let c = [[1,2,3], [4,5,6], [7,8,9]]
c[0][2] // first is row, second is col


allEqual(fields)


let g = fieldsToGrid(fields)

fields.filter { f in f == Field.Marked(Marker.Cross)}

func extractColumns<T>(grid: [[T]]) -> [[T]] {
    var result: [[T]] = []
    for colIndex in 0...grid[0].count-1 {
        var cols: [T] = []
        for rowIndex in 0...grid.count-1 {
            cols.append(grid[rowIndex][colIndex])
        }
        result.append(cols)
        cols = []
    }
    return result
}

func extractDiagonals<T>(grid: [[T]]) -> [[T]] {
    var result: [[T]] = []
    for colIndex in 0...grid[0].count-1 {
        var cols: [T] = []
        for rowIndex in 0...grid.count-1 {
            cols.append(grid[rowIndex][colIndex])
        }
        result.append(cols)
        cols = []
    }
    return result
}

extractColumns(c)


func checkRows(marker: Marker, grid: Grid) -> Marker? {
    for row in grid {
        if allEqual(row) {
            if let firstField = row.first {
                switch firstField {
                    case Field.Marked(let m):
                        if m == marker {
                            return marker
                        }
                        else {
                            return theOtherMarker(marker)
                        }
                    default:
                        return nil
                }
            }
        }
    }
    return nil
}

func checkColumns(marker: Marker, grid: Grid) -> Marker? {
    let mirror = extractColumns(grid) as Grid
    return checkRows(marker, grid: mirror)
}

func checkDiagonals(marker: Marker, grid: Grid) -> Marker? {
    if grid[0][0] == grid[1][1] {
        if grid[1][1] == grid[2][2] {
            switch grid[0][0] {
                case Field.Marked(let m):
                    if m == marker {
                        return marker
                    }
                    else {
                        return theOtherMarker(marker)
                    }
                default:
                    return nil
            }
        }
    }
    if grid[2][0] == grid[1][1] {
        if grid[1][1] == grid[0][2] {
            switch grid[2][0] {
            case Field.Marked(let m):
                if m == marker {
                    return marker
                }
                else {
                    return theOtherMarker(marker)
                }
            default:
                return nil
            }
        }
    }
    return nil
}


func playerWon(marker: Marker, grid: Grid) -> Bool {
    if let w0 = checkRows(marker, grid: grid) {
        return w0 == marker
    }
    else if let w0 = checkColumns(marker, grid: grid) {
        return w0 == marker
    }
    return false
}


0...2 ~= 3

//func makeMove(board: Board, marker: Marker, choice: (Int, Int)) -> BoardOrMsg {
//    assert(0...2 ~= choice.0 && 0...2 ~= choice.1)
//    
//    if board.grid[choice.0][choice.1] == Field.Empty {
//        return BoardOrMsg.Error("Illegal move, (\(choice.0), \(choice.1) is not empty)")
//    }
//    
//    var newGrid = board.grid
//    newGrid[choice.0][choice.1] = Field.Marked(marker)
//    let newBoard = Board(grid)
//    
//    return BoardOrMsg.Board(newBoard)
//}

