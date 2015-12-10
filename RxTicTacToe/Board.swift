//
//  Board.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation

typealias Grid = [[Field]]

enum Marker: Equatable {
    case Circle
    case Cross
}

enum Field {
    case Empty
    case Marked(Marker)
}
 
extension Field: Equatable {

}

func == (lhs: Field, rhs: Field) -> Bool {
    switch (lhs, rhs) {
    case (.Empty, .Empty):
        return true
    case (.Marked(let m1), .Marked(let m2)):
        return m1 == m2
    default:
        return false
    }
}

enum BoardOrMsg {
    case Success(Board)
    case Error(String)
}

struct Board {
    
    // should always contain nine fields
    let grid: Grid
    
    // returns the marker of the player with the next turn (nil if there are no empty fields, thus no turns left)
    var playersTurn: Marker? {
        get {
            let fields = grid.flatMap{$0}
            if (fields.filter {f in f != Field.Empty}.count) == fields.count {
                return nil
            }
            let crossedFields = fields.filter { $0 == Field.Marked(Marker.Cross) }.count
            let circledFields = fields.filter { $0 == Field.Marked(Marker.Circle) }.count
            let marker = circledFields < crossedFields ? Marker.Circle : Marker.Cross
            print("circles: \(circledFields), crossed: \(crossedFields) --> \(marker)")
            return marker
        }
    }
    
    // checks if one of the players won the game (nil if no winner yet or board full)
    var winner: Marker? {
        get {
            if playerWon(Marker.Circle, grid: grid) {
                return Marker.Circle
            }
            else if playerWon(Marker.Cross, grid: grid) {
                return Marker.Cross
            }
            return nil
        }
    }
    
    var canMakeMove: Bool {
        get {
            if (self.winner != nil) {
                return true
            } else {
                return false
            }
        }
    }
    
    init() {
        let fields = [Field](count: 9, repeatedValue:Field.Empty)
        grid = fieldsToGrid(fields)
    }
    
    init(fields: [Field]) {
        grid = fieldsToGrid(fields)
    }
    
    init(grid: [[Field]]) {
        self.grid = grid
    }
}


// MARK: Game

func makeMove(board: Board, marker: Marker, choice: (Int, Int)) -> BoardOrMsg {
    assert(0...2 ~= choice.0 && 0...2 ~= choice.1)
    
    if board.grid[choice.0][choice.1] != Field.Empty {
        return BoardOrMsg.Error("Illegal move, (\(choice.0), \(choice.1) is not empty)")
    }
    
    print("Put \(marker) at position \(choice)")
    
    var newGrid = board.grid
    newGrid[choice.0][choice.1] = Field.Marked(marker)
    let newBoard = Board(grid: newGrid)
    
    return BoardOrMsg.Success(newBoard)
}


// MARK: Helpers

func theOtherMarker(marker: Marker) -> Marker {
    if marker == Marker.Circle {
        return Marker.Cross
    }
    else {
        return Marker.Circle
    }
}

func fieldsToGrid(fields: [Field]) -> Grid {
    return fields.sliceUp(3)
}


// MARK: Check for winner

func playerWon(marker: Marker, grid: Grid) -> Bool {
    if let m = checkRows(marker, grid: grid) {
        return m == marker
    }
    else if let m = checkColumns(marker, grid: grid) {
        return m == marker
    }
    else if let m = checkDiagonals(marker, grid: grid) {
        return m == marker
    }
    return false
}

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
