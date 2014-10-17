//
//  ViewController.swift
//  SlotMachine
//
//  Created by Miguel Angel Moreno Armenteros on 17/10/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fouthContainer: UIView!
    
    /* CONSTANTS */
    let kMarginForView: CGFloat = 10.0
    let kSixth: CGFloat = 1.0/6.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupContainerViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupContainerViews() {
        self.setupFirstContainer()
        self.setupSecondContainer()
        self.setupThirdContainer()
        self.setupFourthContainer()
    }
    
    func setupFirstContainer() {
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: self.view.bounds.height * self.kSixth
        )
        self.firstContainer = UIView(frame: frame)
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.firstContainer)
    }
    
    func setupSecondContainer() {
        /*
         * The view must be position in 'x' and 'width' same as the others
         * but the y position must start at the end of previous container
         * The previous container ends in its origin.y + its height
         */
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.firstContainer.frame.origin.y + self.firstContainer.frame.height,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: self.view.bounds.height * (3 * self.kSixth)
        )
        
        self.secondContainer = UIView(frame: frame)
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.secondContainer)    }

    func setupThirdContainer() {
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.secondContainer.frame.origin.y + self.secondContainer.frame.height,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: self.view.bounds.height * self.kSixth
        )

        self.thirdContainer = UIView(frame: frame)
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.thirdContainer)
    }
    
    func setupFourthContainer() {
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.thirdContainer.frame.origin.y + self.thirdContainer.frame.height,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: self.view.bounds.height * self.kSixth
        )

        self.fouthContainer = UIView(frame: frame)
        self.fouthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.fouthContainer)
    }

}

