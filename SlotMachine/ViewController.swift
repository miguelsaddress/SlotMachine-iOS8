//
//  ViewController.swift
//  SlotMachine
//
//  Created by Miguel Angel Moreno Armenteros on 17/10/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // TO DO:
    // * use didSet observer for credits, currentBet and winnings
    // * Clean the code

    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    var slots:[[Slot]] = []

    //Game vars
    var credits = 0
    var currentBet = 0
    var winnings = 0
    
    //first container Labels
    var titleLabel: UILabel!
    
    //third container Labels
    var creditsLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    var creditsTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    //fourth container's buttons
    var resetButton: UIButton!
    var betOneButton: UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    
    /* CONSTANTS */
    let kMarginForView: CGFloat = 10.0
    let kMarginForSlot:CGFloat = 2.0

    let kHalf: CGFloat = 1.0/2.0
    let kThird: CGFloat = 1.0/3.0
    let kSixth: CGFloat = 1.0/6.0
    let kEigth: CGFloat = 1.0/8.0
    
    let kNumberOfContainers = 3 //columns
    let kNumberOfSlots = 3 //rows per container
    
    
    let tableColor = UIColor(red: 0.25, green: 0.85, blue: 0.3, alpha: 0.92)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.createAndSetupContainerViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions / Target functions
    
    func resetButtonPressed(button:UIButton){
        self.hardReset()
    }
    
    func betOneButtonPressed(button:UIButton){
        if self.credits <= 0 {
            self.showAlertWithtext(header: "No more credits", message: "Reset the game")
        } else {
            if self.currentBet < 5 {
                self.currentBet += 1
                self.credits -= 1
                self.updateMainView()
            } else {
                self.showAlertWithtext(message: "The maximum bet is 5 credits")
            }
        }
    }
    
    func betMaxButtonPressed(button:UIButton){
        if self.credits < 5 {
            self.showAlertWithtext(header: "Not enough credits", message: "Bet Less")
        } else {
            if self.currentBet < 5 {
                var creditsToBetMax = 5 - self.currentBet
                self.currentBet += creditsToBetMax
                self.credits -= creditsToBetMax
                self.updateMainView()
            } else {
                self.showAlertWithtext(message: "The maximum bet is 5 credits")
            }
        }
    }
    
    func spinButtonPressed(button:UIButton){
        if self.currentBet <= 0 {
            self.showAlertWithtext(message: "You did not bet anything!")
            return
        }
        
        self.removeSlotImageViews()
        self.slots = Factory.createSlots(containers: self.kNumberOfContainers, slots: self.kNumberOfSlots)
        self.setupSecondContainer(self.secondContainer)
        
        var winningsTuple = SlotBrain.computeWinnings(self.slots)
        var winningsMultiplier = winningsTuple.winnings
        if winningsMultiplier > 0 {
            var wonNow = self.currentBet * winningsMultiplier
            self.winnings += wonNow

            var text = "You Won \(wonNow) credits!\n"
            if winningsTuple.matches.flush > 0 {
                text += "* Flush: \(winningsTuple.matches.flush) x \(self.currentBet) bet Credit(s)\n"
            }
            
            if winningsTuple.matches.threeOfAKind > 0 {
                text += "* 3 of a Kind: \(winningsTuple.matches.threeOfAKind) x \(self.currentBet) bet Credit(s)\n"
            }
            
            if winningsTuple.matches.threeOfAKind > 0 {
                text += "* Straight: \(winningsTuple.matches.straight) x \(self.currentBet) bet Credit(s)\n"
            }

            self.showAlertWithtext(header: "YUHUUU", message: text, style:UIAlertControllerStyle.ActionSheet)
            
        }

        self.currentBet = 0
        self.updateMainView()
    }
    
    func removeSlotImageViews() {
        if self.secondContainer != nil {
            let container: UIView? = self.secondContainer
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        self.removeSlotImageViews()
        self.slots.removeAll(keepCapacity: true) //because we are gonna fill it up again soon
        
        self.credits = 500
        self.currentBet = 0
        self.winnings = 0
        
        self.setupSecondContainer(self.secondContainer)
        self.updateMainView()
    }
    
    func updateMainView() {
        self.creditsLabel.text = "\(self.credits)"
        self.betLabel.text = "\(self.currentBet)"
        self.winnerPaidLabel.text = "\(self.winnings)"
    }
    
    func showAlertWithtext(header: String = "Warning", message: String, style:UIAlertControllerStyle = UIAlertControllerStyle.Alert) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: style)
        var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion:nil)
    }

    
    
  
    // View Stuff
    

    func createAndSetupContainerViews() {
        self.createAndAttachFirstContainer()
        self.createAndAttachSecondContainer()
        self.createAndAttachThirdContainer()
        self.createAndAttachFourthContainer()
        self.hardReset()
    }
    
    func createAndAttachFirstContainer() {
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.view.bounds.origin.y + 20,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: (self.view.bounds.height * self.kSixth) - 40
        )
        self.firstContainer = UIView(frame: frame)
        self.firstContainer.backgroundColor = UIColor.orangeColor()
        
        self.firstContainer.layer.borderColor = UIColor.redColor().CGColor
        self.firstContainer.layer.borderWidth = CGFloat(3.0)

        //borders
        self.firstContainer.layer.masksToBounds = true
        self.firstContainer.layer.cornerRadius = 8

        
        self.view.addSubview(self.firstContainer)
        self.setupFirstContainer(self.firstContainer)
        
    }
    
    func setupFirstContainer(container:UIView) {
        /*
         * The container contains the Title of the app
         */
        
        let frame = CGRect(
            x: container.bounds.origin.x + 80,
            y: container.bounds.origin.y,
            width: container.frame.width,
            height: container.frame.height
        )
        //Adding title label
        self.titleLabel = UILabel(frame: frame)
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()

        // more fonts here http://iosfonts.com/
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        
        container.addSubview(self.titleLabel)
    }
    
    func createAndAttachSecondContainer() {
        /*
         * The view must be position in 'x' and 'width' same as the others
         * but the y position must start at the end of previous container
         * The previous container ends in its origin.y + its height
         */
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView + 40,
            y: self.firstContainer.frame.origin.y + self.firstContainer.frame.height + 5,
            width: self.view.bounds.width - (2 * self.kMarginForView) - 80,
            height: self.view.bounds.height * (3 * self.kSixth) - 40
        )
        
        self.secondContainer = UIView(frame: frame)
        self.secondContainer.backgroundColor = self.tableColor

        self.view.addSubview(self.secondContainer)
        self.setupSecondContainer(self.secondContainer)

    }
    
    func setupSecondContainer(container:UIView) {
        /*
         * This container keeps the views where the cards will be set.
         */
        for var containerNumber = 0; containerNumber < self.kNumberOfContainers; containerNumber++ {
            for var slotNumber = 0; slotNumber < self.kNumberOfSlots; slotNumber++ {
                
                var slot: Slot
                var slotImageView = UIImageView()
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
                    width: (container.bounds.width * self.kThird),
                    height: (container.bounds.height * self.kThird)
                )
                slotImageView.frame = frame
                
                slotImageView.layer.borderColor = UIColor.blackColor().CGColor
                slotImageView.layer.borderWidth = CGFloat(3.0)
                
                if self.slots.count != 0 {
                    let slotContainer = self.slots[containerNumber]
                    slot = slotContainer[slotNumber]
                    slotImageView.image = slot.image
                } else {
                    slotImageView.image = UIImage(named: "Ace")
                }

                container.addSubview(slotImageView)

            }
        }
    }

    func createAndAttachThirdContainer() {
        let frame = CGRect(
            x: self.view.bounds.origin.x + self.kMarginForView,
            y: self.secondContainer.frame.origin.y + self.secondContainer.frame.height + 10,
            width: self.view.bounds.width - (2 * self.kMarginForView),
            height: self.view.bounds.height * self.kSixth
        )

        self.thirdContainer = UIView(frame: frame)
        let color = UIColor(red: 0.53, green: 0.82, blue: 0.72, alpha: 0.82)
        self.thirdContainer.backgroundColor = color

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
    
    func createNumberLabel(frame:CGRect, center:CGPoint) -> UILabel {
        var label = UILabel(frame: frame)
        label.text = "000000"
        label.textColor = UIColor.redColor()
        label.font = UIFont(name: "Menlo-Bold", size: 16)
        label.center = center
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.whiteColor()
        
        //borders
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        
        return label

    }
    
    func makeCreditsLabel(container:UIView){
        let frame = CGRect(
            x: container.bounds.origin.x + 1 * self.kSixth,
            y: container.frame.origin.y + 30,
            width: container.bounds.width * (1.0/4.0),
            height: container.bounds.height * self.kThird
        )
        let center = CGPoint(x: container.frame.width * self.kSixth, y: container.frame.height * self.kThird)
        self.creditsLabel = self.createNumberLabel(frame, center: center)
        container.addSubview(self.creditsLabel)
    }
    
    func makeBetLabel(container:UIView){
        let frame = CGRect(
            x: container.bounds.origin.x + 3 * self.kSixth,
            y: container.frame.origin.y + 30,
            width: container.bounds.width * (1.0/4.0),
            height: container.bounds.height * self.kThird
        )

        let center = CGPoint(x: container.frame.width * (3 * self.kSixth), y: container.frame.height * self.kThird)
        self.betLabel = self.createNumberLabel(frame, center: center)
        container.addSubview(self.betLabel)

    }
    
    func makeWinnerPaidLabel(container: UIView) {
        
        let frame = CGRect(
            x: container.bounds.origin.x + 5 * self.kSixth,
            y: container.frame.origin.y + 30,
            width: container.bounds.width * (1.0/4.0),
            height: container.bounds.height * self.kThird
        )
        
        let center = CGPoint(x: container.frame.width * (5 * self.kSixth), y: container.frame.height * self.kThird)
        self.winnerPaidLabel = self.createNumberLabel(frame, center: center)
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
            height: self.view.bounds.height * self.kSixth + 40
        )

        self.fourthContainer = UIView(frame: frame)
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.fourthContainer)
        self.setupFourthContainer(self.fourthContainer)
    }
    
    func setupFourthContainer(container:UIView) {
        //the container contains the buttons for the actions
        self.makeResetButton(container)
        self.makeBetOneButton(container)
        self.makeBetMaxButton(container)
        self.makeSpinButton(container)
    }
    
    func makeResetButton(container:UIView){
        
        let frame = CGRect(
            x: container.bounds.origin.x + 10,
            y: container.bounds.origin.y + 50,
            width: container.bounds.width * self.kEigth + 10,
            height: container.bounds.height * self.kThird
        )

        self.resetButton = self.makeButton(frame: frame, title:"Reset", action: "resetButtonPressed:")
        container.addSubview(self.resetButton)
    }
    
    func makeBetOneButton(container:UIView){
        
        let frame = CGRect(
            x: container.bounds.origin.x + self.resetButton.bounds.width + 30,
            y: container.bounds.origin.y + 50,
            width: container.bounds.width * self.kEigth + 20,
            height: container.bounds.height * self.kThird
        )
        
        self.betOneButton = self.makeButton(frame: frame, title:"Bet 1", action: "betOneButtonPressed:")
        container.addSubview(self.betOneButton)
    }
    
    func makeBetMaxButton(container:UIView){
        
        let frame = CGRect(
            x: container.bounds.origin.x + self.resetButton.bounds.width + self.betOneButton.bounds.width + 50,
            y: container.bounds.origin.y + 50,
            width: container.bounds.width * self.kEigth + 40,
            height: container.bounds.height * self.kThird
        )
        
        self.betMaxButton = self.makeButton(frame: frame, title: "Bet Max", action: "betMaxButtonPressed:")
        container.addSubview(self.betMaxButton)
    }
    
    func makeSpinButton(container:UIView){
        
        let frame = CGRect(
            x: container.bounds.width - (container.bounds.width * 2 * self.kEigth) + 25,
            y: container.bounds.origin.y + 50,
            width: container.bounds.width * self.kEigth + 10,
            height: container.bounds.height * self.kThird
        )

        self.spinButton = self.makeButton(frame: frame, title: "Spin", action: "spinButtonPressed:",
                                          backgroundColor:UIColor.orangeColor(), borderColor:UIColor.yellowColor())
        container.addSubview(self.spinButton)
    }
    
    func makeButton(#frame:CGRect, title:String, action:String, backgroundColor: UIColor = UIColor.whiteColor(), borderColor: UIColor = UIColor.orangeColor()) -> UIButton {
        
        var btn = UIButton(frame: frame)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        btn.backgroundColor = backgroundColor
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 25
        btn.layer.borderColor = borderColor.CGColor
        btn.layer.borderWidth  = CGFloat(2.0)
        
        btn.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }

    
}

