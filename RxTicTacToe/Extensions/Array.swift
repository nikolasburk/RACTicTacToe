//
//  Array.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation


extension Array {
    
    func sliceUp(pieces: Int) -> [[Element]] {
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