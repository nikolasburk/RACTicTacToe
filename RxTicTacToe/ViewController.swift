//
//  ViewController.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import UIKit
import ReactiveCocoa


class ViewController: UIViewController {

    // Game
    let game = MutableProperty<Game?>(nil)
    
    // UI elements
    let gridView: MutableProperty<GridView>
    let startButton: UIButton
    let whosTurnLabel: UILabel
    let winnerLabel: UILabel
    let name1TextField: UITextField
    let name2TextField: UITextField
    let namesLabel: UILabel
    
    // View model
    let viewModel: ViewModel
    
    
    // MARK: Init and lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        
        // Create (and partly configure) the UI elements
        self.gridView = MutableProperty(createGridView())
        self.startButton = createButton("Start new game")
        self.whosTurnLabel = createLabel("Enter names of players")
        self.winnerLabel = createLabel("No winner yet")
        self.name1TextField = createTextField("Enter name of player 1")
        self.name2TextField = createTextField("Enter name of player 2")
        self.namesLabel = createLabel("No active game")
        self.namesLabel.textAlignment = NSTextAlignment.Right
        self.namesLabel.backgroundColor = UIColor.yellowColor()
        
        // Instantiate view model
        self.viewModel = ViewModel()

        // Bind view model properties to labels
        self.namesLabel.rac_text <~ self.viewModel.names
        self.whosTurnLabel.rac_text <~ self.viewModel.whosTurn
        self.winnerLabel.rac_text <~ self.viewModel.winner
        self.gridView.value.rac_userInteractionEnabled <~ self.viewModel.canMakeMove

        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        // Add views and constraints
        self.view.addSubview(self.gridView.value)
        setupConstraintsForGridView()
        self.view.addSubview(self.whosTurnLabel)
        self.view.addSubview(self.winnerLabel)
        setupConstraintsForInfoLabels()
        self.view.addSubview(self.name1TextField)
        self.view.addSubview(self.name2TextField)
        self.view.addSubview(self.namesLabel)
        setupConstraintsForNameElements()
        self.view.addSubview(self.startButton)
        setupConstraintsForStartButton()

        // Configure the start button
        configureStartButton()
        
        // Configure the game property for KVO
        self.game.producer.start {
            print("new game: \($0.value)")
            if let maybeGame = $0.value {
                if let game = maybeGame {
                    self.viewModel.newGame(game)
                }
            }
        }
        
        // Observe taps on the grid
        gridViewSignal()
    }
    
    
    // MARK: Game
    
    func playerTappedCell(position: Position) {
        guard let game = self.game.value else {
            print("No active game")
            return
        }

        print("make move \(position)")
        
        if let currentPlayer = game.board.playersTurn {
            let boardOrMsg = makeMove(game.board, marker: currentPlayer, choice: position)
            switch boardOrMsg {
                case .Error(let msg): displayErrorMsgForInvalidMove(msg)
                case .Success(let newBoard):
                    self.gridView.value.updateCell(atPosition: position, withMarker: currentPlayer)
                    updateGame(newBoard)
            }
        }
    }

    func displayErrorMsgForInvalidMove(msg: String) {
        print("ERROR: \(msg)")
    }
    
    func updateGame(newBoard: Board) {
        guard let game = self.game.value else {
            print("No active game")
            return
        }

        print(self.game.value)
        self.game.value = Game(players: game.players, board: newBoard)
        if let winner = self.game.value?.board.winner {
            self.viewModel.winner.value = "The winner is \(winner)"
            self.viewModel.canMakeMove.value = false
        }
    }
    
    
    // MARK: RAC Signals
    
    func addSignalProducer() {
        let nameStrings = self.name1TextField
            .rac_textSignal()
            .toSignalProducer()
            .map {text in text as! String}
        nameStrings.startWithNext {
            s in print(s)
        }
        print(nameStrings)
    }
    
    func createTapSignal() -> Signal<Position, NoError>? {
        var signals: [Signal<Position, NoError>] = []
        for maybeTap in self.gridView.value.cellsTapGestureRecognizers() {
            if let tap = maybeTap {
                let signal = tap.gestureSignalView()
                    .map { $0 as! GridViewCell }
                    .map { $0.position }
                signals.append(signal)
            }
        }
        
        return signals.count > 0 ? Signal.merge(signals) : nil
    }
    
    func gridViewSignal() -> Signal <GridView, NoError>? {
        if let taps = createTapSignal() {
            return taps.map { position in
                self.playerTappedCell(position)
                return self.gridView.value
            }
        }
        return nil
    }
    
    func configureStartButton() {
        
        self.startButton
                .signalForControlEvents(UIControlEvents.TouchUpInside)
                .map { _ in (self.name1TextField.text!, self.name2TextField.text!)}
                .observe { event in
                    if let names = event.value {
                        print("received names \(names)")
                        let game = Game(playersNames: names)
                        self.game.value = game
                        self.gridView.value.clear()
                        self.viewModel.canMakeMove.value = true

                    }
                }
        
        /**
        // come back to this when we know how to bind
        // signal to enabled property of UIButton
        let name1Signal = self.name1TextField.rac_textSignal()
                .toSignalAssumingHot()
                .assumeNoErrors()
                .map { text in text as! String }
                .map { $0.characters.count }

        let name2Signal = self.name2TextField.rac_textSignal()
                .toSignalAssumingHot()
                .assumeNoErrors()
                .map { text in text as! String }
                .map { $0.characters.count }

        let combinedNameSignals = name1Signal.combineLatestWith(name2Signal)
                                    .map { $0.0 > 0 && $0.1 > 0 }
        */
        
    }
    

    // MARK: Setup autolayout constraints
    
    func setupConstraintsForGridView() {
        self.gridView.value.translatesAutoresizingMaskIntoConstraints = false
        
        // add centering constraints
        NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView.value, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant:0).active = true
        NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView.value, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant:0).active = true

        // add width/height constraints
        NSLayoutConstraint(item: self.gridView.value, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500).active = true
        NSLayoutConstraint(item: self.gridView.value, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500).active = true
    }

    func setupConstraintsForInfoLabels() {
        self.whosTurnLabel.translatesAutoresizingMaskIntoConstraints = false
        self.winnerLabel.translatesAutoresizingMaskIntoConstraints = false

        // center x
        NSLayoutConstraint(item: self.gridView.value, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.whosTurnLabel, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        // distance to grid view
        NSLayoutConstraint(item: self.gridView.value, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.whosTurnLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:45).active = true
        
        // center x
        NSLayoutConstraint(item: self.winnerLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView.value, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        // distance to grid view
        NSLayoutConstraint(item: self.winnerLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView.value, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant:45).active = true

    }
    
    func setupConstraintsForNameElements() {
        self.name1TextField.translatesAutoresizingMaskIntoConstraints = false
        self.name2TextField.translatesAutoresizingMaskIntoConstraints = false
        self.namesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // place name1TextField on top left
        NSLayoutConstraint(item: self.name1TextField, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 40).active = true
        NSLayoutConstraint(item: self.name1TextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 40).active = true
        
        // add width/height constraints to name1TextField
        NSLayoutConstraint(item: self.name1TextField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 220).active = true
        NSLayoutConstraint(item: self.name1TextField, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40).active = true
        
        // place name2TextField right below name1TextField
        NSLayoutConstraint(item: self.name2TextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.name1TextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8).active = true
        NSLayoutConstraint(item: self.name2TextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal,
            toItem: self.name1TextField, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0).active = true
        
        // make name2TextField same size as name1TextField
        NSLayoutConstraint(item: self.name2TextField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: self.name1TextField, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: self.name2TextField, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: self.name1TextField, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0).active = true
        
        // place names label on top right
        NSLayoutConstraint(item: self.namesLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -40).active = true
        NSLayoutConstraint(item: self.namesLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 40).active = true
        
        // add width/height constraints to names label
        let heightConstraint = NSLayoutConstraint(item: self.namesLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300)
        heightConstraint.priority = UILayoutPriorityDefaultHigh
        heightConstraint.active = true
        NSLayoutConstraint(item: self.namesLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40).active = true
        
        // change priority of compression resistancy and width constraints
        self.namesLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
    
    }

    func setupConstraintsForStartButton() {
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        
        // place start button right below name text fields
        NSLayoutConstraint(item: self.startButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.name2TextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8).active = true
        NSLayoutConstraint(item: self.startButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal,
            toItem: self.name2TextField, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0).active = true
        
        // add width/height constraints to start button
        NSLayoutConstraint(item: self.startButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 135).active = true
        NSLayoutConstraint(item: self.namesLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75).active = true
        
    }
}



// MARK: RAC helpers

//let action = Action<Void, String, NoError> {
////    return SignalProducer.never // this works as well
//    return SignalProducer(value: "hello")
//}
//let cocoaAction = CocoaAction(action) { x in
//    print("button tapped \(x)")
//    if let button = x {
//        if let title = button.titleLabel!!.text {
//            print("the button with title ---\(title)--- was pressed")
//        }
//    }
//}
////Dummy action for now. Will make a network request using the text property in the real app.
//action = Action { s in
//    return SignalProducer { sink, _ in
//        print("sending something... \(s)")
//        let p0 = Player(name: s.0, marker: Marker.Cross)
//        let p1 = Player(name: s.1, marker: Marker.Circle)
//        sink.sendNext(Game(players: (p0, p1))) // the argument passed to sendNext needs to be of the Output type of the Action
//        sink.sendCompleted()
//    }
//}
//startButtonAction = CocoaAction(action) { _ in
//    return (self.name1TextField.text!, self.name2TextField.text!)
//}



func createCocoaAction(textField1: UITextField? = nil, textField2: UITextField? = nil) -> CocoaAction {
    let someAction = Action<Void, String, NoError> {
        return SignalProducer.empty
    }
    let cocoaAction = CocoaAction(someAction) { x in
        if let button = x {
            if let title = button.titleLabel!!.text {
                print("the button with title ---\(title)--- was pressed")
            }
        }
    }
    return cocoaAction
}


// MARK: Create UI elements

func createGridView(tapHandler: (Position -> ())? = nil) -> GridView {
    let gridViewFrame = CGRectMake(0.0, 0.0, 500.0, 500.0)
    return GridView(frame: gridViewFrame, tapHandler: tapHandler)
}

func createButton(title: String) -> UIButton {
    let button = UIButton(type: UIButtonType.System)
    button.setTitle(title, forState: .Normal)
    button.backgroundColor = UIColor.redColor()
    return button
}

func createLabel(title: String) -> UILabel {
    let label = UILabel(frame: CGRectZero)
    label.text = title
    label.sizeToFit()
    return label
}

func createTextField(placeholder: String) -> UITextField {
    let textField = UITextField(frame: CGRectZero)
    textField.backgroundColor = UIColor.greenColor()
    textField.placeholder = placeholder
    textField.clearButtonMode = .Always
    return textField
}



