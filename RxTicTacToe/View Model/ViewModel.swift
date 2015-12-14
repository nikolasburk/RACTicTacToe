//
//  ViewModel.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 10/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct ViewModel {
    
    let whosTurn: MutableProperty<String> = MutableProperty("No active game")
    let names: MutableProperty<String> = MutableProperty("Please enter names of players")
    let winner: MutableProperty<String> = MutableProperty("No winner yet")
    
    let canMakeMove: MutableProperty<Bool> = MutableProperty(false)
    
    func newGame(game: Game) {
        
        // update the names of the players
        let p0 = game.players.0
        let p1 = game.players.1
        self.names.value = "\(p0.name) (X) vs \(p1.name) (O)"
        
        // reset the winner label
        self.winner.value = "No winner yet"
        
        // determine who's turn it is (although it's probably Cross as Cross always begins)
        if let marker = game.board.playersTurn {
            self.whosTurn.value = "Current turn: \(marker)"
        } else {
            self.whosTurn.value = "I can't tell whose turn it is..."
        }
        
    }
    
}
