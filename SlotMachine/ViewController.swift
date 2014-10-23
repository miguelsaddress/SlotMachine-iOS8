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
        
        var winningsMultiplier = SlotBrain.computeWinnings(self.slots)
        if winningsMultiplier > 0 {
            var wonNow = self.currentBet * winningsMultiplier
            self.winnings += wonNow
            self.showAlertWithtext(header: "YUHUUU", message: "You Won \(wonNow) credits!")
            
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
        self.slots.removeAll(keepCapacity: true) //we are gonna fill it up again soon
        
        self.credits = 50
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
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion:nil)
    }

    
    
    
    
    
    
    
    
    
    
    

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
                    width: (container.bounds.width * self.kThird) - self.kMarginForSlot,
                    height: (container.bounds.height * self.kThird) - self.kMarginForSlot
                )
                slotImageView.frame = frame
                
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
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPoint(x: container.frame.width * self.kEigth, y: container.frame.height * self.kHalf)
        
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        container.addSubview(self.resetButton)
    }
    
    func makeBetOneButton(container:UIView){
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: container.frame.width * 3 * self.kEigth, y: container.frame.height * self.kHalf)
        
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        container.addSubview(self.betOneButton)

    }
    
    func makeBetMaxButton(container:UIView){
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.redColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: container.frame.width * 5.0 * self.kEigth, y: container.frame.height * self.kHalf)
        
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        container.addSubview(self.betMaxButton)

    }
    
    func makeSpinButton(container:UIView){
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: container.frame.width * 7.0 * self.kEigth, y: container.frame.height * self.kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        container.addSubview(self.spinButton)

    }
    
}

