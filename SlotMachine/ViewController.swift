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
    
    //first container Labels
    var titleLabel: UILabel!
    
    //third container Labels
    var creditsLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    var creditsTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    /* CONSTANTS */
    let kMarginForView: CGFloat = 10.0
    let kMarginForSlot:CGFloat = 2.0

    let kSixth: CGFloat = 1.0/6.0
    let kThird: CGFloat = 1.0/3.0

    let kNumberOfContainers = 3 //columns
    let kNumberOfSlots = 3 //rows per container
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.createAndSetupContainerViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createAndSetupContainerViews() {
        self.createAndAttachFirstContainer()
        self.createAndAttachSecondContainer()
        self.createAndAttachThirdContainer()
        self.createAndAttachFourthContainer()
    }
    
    func createAndAttachFirstContainer() {
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: self.view.bounds.height * self.kSixth
        )
        self.firstContainer = UIView(frame: frame)
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.firstContainer)
        self.setupFirstContainer(self.firstContainer)
        
    }
    
    func setupFirstContainer(container:UIView) {
        /*
         * The container contains the Title of the app
         */
        
        //Adding title label
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()

        // more fonts here http://iosfonts.com/
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = container.center
        
        container.addSubview(self.titleLabel)
    }
    
    func createAndAttachSecondContainer() {
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
        self.view.addSubview(self.secondContainer)
        self.setupSecondContainer(self.secondContainer)
    }
    
    func setupSecondContainer(container:UIView) {
        /*
         * This container keeps the views where the cards will be set. TBD
         */
        for var containerNumber = 0; containerNumber < self.kNumberOfContainers; containerNumber++ {
            for var slotNumber = 0; slotNumber < self.kNumberOfSlots; slotNumber++ {
                /*
                * x: starting in the x-origin of the container plus a third of its width   * position (0, 1, 2)
                *    So we take into account the previous columns already set
                * y: starting at the y-origin of the container, plus a third of its height * position (0, 1, 2)
                *    So we take into account the previous columns already set
                * width: a third of the container's width minus a constant, to make a separation
                * height: a third of the container's heigh minus a constant, to make a separation
                */
                let frame = CGRect(
                    x: container.bounds.origin.x + (container.bounds.size.width * CGFloat(containerNumber) * self.kThird),
                    y: container.bounds.origin.y + (container.bounds.size.height * CGFloat(slotNumber) * self.kThird),
                    width: (container.bounds.width * self.kThird) - self.kMarginForSlot,
                    height: (container.bounds.height * self.kThird) - self.kMarginForSlot
                )
                var slotImageView = UIImageView(frame: frame)
                slotImageView.backgroundColor = UIColor.yellowColor()
                container.addSubview(slotImageView)

            }
        }
    }

    func createAndAttachThirdContainer() {
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.secondContainer.frame.origin.y + self.secondContainer.frame.height,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: self.view.bounds.height * self.kSixth
        )

        self.thirdContainer = UIView(frame: frame)
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.thirdContainer)
        self.setupThirdcontainer(self.thirdContainer)
    }
    
    func setupThirdcontainer(container:UIView) {
        //the container contains the information labels
        self.makeCreditsLabel(container)
        self.makeBetLabel(container)
        self.makeWinnerPaidLabel(container)
        self.makeCreditsTitleLabel(container)
        self.makeBetTitleLabel(container)
        self.makeWinnerPaidTitleLabel(container)
    }
    
    func makeCreditsLabel(container:UIView){
        self.creditsLabel = UILabel()
        self.creditsLabel.text = "000000"
        self.creditsLabel.textColor = UIColor.redColor()
        self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.creditsLabel.sizeToFit()
        self.creditsLabel.center = CGPoint(x: container.frame.width * self.kSixth, y: container.frame.height * self.kThird)
        self.creditsLabel.textAlignment = NSTextAlignment.Center
        self.creditsLabel.backgroundColor = UIColor.darkGrayColor()
        container.addSubview(self.creditsLabel)
    }
    
    func makeBetLabel(container:UIView){
        self.betLabel = UILabel()
        self.betLabel.text = "000000"
        self.betLabel.textColor = UIColor.redColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPoint(x: container.frame.width * (3 * self.kSixth), y: container.frame.height * self.kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
        self.betLabel.backgroundColor = UIColor.darkGrayColor()
        container.addSubview(self.betLabel)

    }
    
    func makeWinnerPaidLabel(container: UIView) {
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
        self.winnerPaidLabel.textColor = UIColor.redColor()
        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPoint(x: container.frame.width * (5 * self.kSixth), y: container.frame.height * self.kThird)
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
        self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        container.addSubview(self.winnerPaidLabel)

    }

    func makeCreditsTitleLabel(container: UIView) {
        self.creditsTitleLabel = UILabel()
        self.creditsTitleLabel.text = "Credits"
        self.creditsTitleLabel.textColor = UIColor.blackColor()
        self.creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.creditsTitleLabel.sizeToFit()
        self.creditsTitleLabel.center = CGPoint(x: container.frame.width * self.kSixth, y: container.frame.height * 2 * self.kThird)
        self.creditsTitleLabel.textAlignment = NSTextAlignment.Center
        container.addSubview(self.creditsTitleLabel)

    }

    func makeBetTitleLabel(container: UIView) {
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPoint(x: container.frame.width * (3 * self.kSixth), y: container.frame.height * 2 * self.kThird)
        self.betTitleLabel.textAlignment = NSTextAlignment.Center
        container.addSubview(self.betTitleLabel)
 
    }

    func makeWinnerPaidTitleLabel(container: UIView) {
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winner Paid"
        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
        self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPoint(x: container.frame.width * (5 * self.kSixth), y: container.frame.height * 2 * self.kThird)
        self.winnerPaidTitleLabel.textAlignment = NSTextAlignment.Center
        container.addSubview(self.winnerPaidTitleLabel)

    }

    
    
    
    func createAndAttachFourthContainer() {
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

