//
//  Game.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation

struct Player {
    let name: String
    let marker: Marker
}

struct Game: CustomDebugStringConvertible {
    
    let board: Board
    let players: (Player, Player)
    
    init(players: (Player, Player), board: Board = Board()) {
        self.players = players
        self.board = board
    }
    
    init(playersNames: (String, String)) {
        let p0 = Player(name: playersNames.0, marker: .Cross)
        let p1 = Player(name: playersNames.1, marker: .Circle)
        self.players = (p0, p1)
        self.board = Board()
    }
    
    var debugDescription : String {
        return "\(self.players.0.name) (X) vs \(self.players.1.name) (O) "
    }

}