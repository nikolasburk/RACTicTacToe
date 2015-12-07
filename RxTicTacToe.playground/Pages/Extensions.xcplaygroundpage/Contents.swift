

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

func allEqual<T: Equatable>(a: [T]) -> Bool {
    if let firstElem = a.first {
        return !a.contains {$0 != firstElem}
    }
    return false
}

let a = [1,2,3,4]

allEqual(a)

let b = a.contains {$0 == 1}
b

func diagionals<T>(a: [[T]]) -> [[(Int, Int)]] {
    assert(!a.isEmpty && a.count == a[0].count)
    var result: [[(Int, Int)]] = []
    for row in 0...a.count-1 {
        for col in 0...a.count-1 {
            result.append((row, col))
        }
    }
    return []
}
