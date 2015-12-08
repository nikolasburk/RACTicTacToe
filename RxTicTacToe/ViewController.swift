//
//  ViewController.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // UI elements
    let gridView: GridView
    let restartButton: UIButton
    let whosTurnLabel: UILabel
    let winnerLabel: UILabel

    
    // MARK: Init and lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        self.gridView = createGridView()
        self.restartButton = createRestartButton()
        self.whosTurnLabel = createLabel("Cross's turn")
        self.winnerLabel = createLabel("No winner yet")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.view.addSubview(self.gridView)
        setupConstraintsForGridView()
        self.view.addSubview(self.whosTurnLabel)
        self.view.addSubview(self.winnerLabel)
        setupConstraintsForLabels()
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
        // center x
        NSLayoutConstraint(item: self.gridView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.whosTurnLabel, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        // distance to grid view
        NSLayoutConstraint(item: self.gridView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: self.whosTurnLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:45).active = true
        
        self.winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        // center x
        NSLayoutConstraint(item: self.winnerLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        // distance to grid view
        NSLayoutConstraint(item: self.winnerLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
            toItem: self.gridView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant:45).active = true

    }
}


// MARK: Create UI elements

func createGridView() -> GridView {
    let gridViewFrame = CGRectMake(0.0, 0.0, 500.0, 500.0)
    return GridView(frame: gridViewFrame)
}

func createRestartButton() -> UIButton {
    let button = UIButton(type: UIButtonType.System)
    button.titleLabel?.text = "Restart"
    return button
}

func createLabel(title: String) -> UILabel {
    let label = UILabel(frame: CGRectZero)
    label.text = title
    label.sizeToFit()
    return label
}


