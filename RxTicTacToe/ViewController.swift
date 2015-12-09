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

    func someFunc(pos: Position) {
        print("received \(pos)")
    }
    
    // UI elements
    let gridView: GridView
    let restartButton: UIButton
    let whosTurnLabel: UILabel
    let winnerLabel: UILabel
    let nameTextField: UITextField
    let okButton: UIButton
    
    
    // MARK: Init and lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        self.gridView = createGridView()
        self.restartButton = createButton("Restart")
        self.whosTurnLabel = createLabel("Cross's turn")
        self.winnerLabel = createLabel("No winner yet")
        self.nameTextField = createTextField()
        self.okButton = createButton("OK")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.view.addSubview(self.gridView)
        setupConstraintsForGridView()
        self.view.addSubview(self.whosTurnLabel)
        self.view.addSubview(self.winnerLabel)
        setupConstraintsForLabels()
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.okButton)
        setupConstraintsForNameElements()

        if let taps = createTapSignal() {
         
            taps.observe { event in
                switch event {
                    case .Next(let val): self.someFunc(val)
                    default: print("oups...")
                }
            }
            
        }
        
    }
    
    func addSignalProducer() {
        let nameStrings = self.nameTextField.rac_textSignal().toSignalProducer().map {text in text as! String}
        nameStrings.startWithNext {
            s in print(s)
        }
        print(nameStrings)
    }

    func createSignal() -> Signal<String, NoError> {
        var count = 0
        return Signal {
            sink in
            NSTimer.schedule(repeatInterval: 1.0) { timer in
                sink.sendNext("tick #\(count++)")
            }
            return nil
        }
    }
    
    func createTapSignal() -> Signal<Position, NoError>? {
        var signals: [Signal<Position, NoError>] = []
        for maybeTap in self.gridView.cellsTapGestureRecognizers() {
            if let tap = maybeTap {
                let signal = tap.gestureSignalView()
                    .map { $0 as! GridViewCell }
                    .map {$0.position}
                signals.append(signal)
            }
        }
        
        return signals.count > 0 ? Signal.merge(signals) : nil
    }
    
    
    // MARK: Setup autolayout constraints
    
    func setupConstraintsForGridView() {
        self.gridView.translatesAutoresizingMaskIntoConstraints = false
        
        // add centering constraints
        NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant:0).active = true
        NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant:0).active = true

        // add width/height constraints
        NSLayoutConstraint(item: self.gridView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500).active = true
        NSLayoutConstraint(item: self.gridView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500).active = true
    }

    func setupConstraintsForLabels() {
        self.whosTurnLabel.translatesAutoresizingMaskIntoConstraints = false
        self.winnerLabel.translatesAutoresizingMaskIntoConstraints = false

        // center x
        NSLayoutConstraint(item: self.gridView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.whosTurnLabel, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        // distance to grid view
        NSLayoutConstraint(item: self.gridView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.whosTurnLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:45).active = true
        
        // center x
        NSLayoutConstraint(item: self.winnerLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        // distance to grid view
        NSLayoutConstraint(item: self.winnerLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant:45).active = true

    }
    
    func setupConstraintsForNameElements() {
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.okButton.translatesAutoresizingMaskIntoConstraints = false
        
        // top left
        NSLayoutConstraint(item: self.nameTextField, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 45).active = true
        NSLayoutConstraint(item: self.nameTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 45).active = true
        
        // add width/height constraints to text field
        NSLayoutConstraint(item: self.nameTextField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250).active = true
        NSLayoutConstraint(item: self.nameTextField, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50).active = true
        
        // place button right to text field
        NSLayoutConstraint(item: self.okButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: self.nameTextField, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 20).active = true
        NSLayoutConstraint(item: self.okButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: self.nameTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0).active = true
        
        // add width/height constraints to ok button
        NSLayoutConstraint(item: self.okButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 60).active = true
        NSLayoutConstraint(item: self.okButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35).active = true

    }
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
//    print("\(button) --> \(button.titleLabel?.text))")
    return button
}

func createLabel(title: String) -> UILabel {
    let label = UILabel(frame: CGRectZero)
    label.text = title
    label.sizeToFit()
    return label
}

func createTextField() -> UITextField {
    let textField = UITextField(frame: CGRectZero)
    textField.backgroundColor = UIColor.greenColor()
    textField.placeholder = "Enter name of player"
    return textField
}


// taken from https://gist.github.com/natecook1000/b0285b518576b22c4dc8 (Nate Cook)
extension NSTimer {
    
    // - Returns: The newly-created `NSTimer` instance.
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    // - Returns: The newly-created `NSTimer` instance.
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}


