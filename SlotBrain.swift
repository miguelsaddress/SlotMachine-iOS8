//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Miguel Angel Moreno Armenteros on 23/10/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import Foundation

class SlotBrain {

    class func unpackSlotIntoSlotRows( slots: [[Slot]]) -> [[Slot]] {
        var firstRow: [Slot] = []
        var secondRow: [Slot] = []
        var thirdRow: [Slot] = []
        
        let firstCol = slots[0]
        let secondCol = slots[1]
        let thirdCol = slots[2]
        
        firstRow.append(firstCol[0])
        firstRow.append(secondCol[0])
        firstRow.append(thirdCol[0])

        
        secondRow.append(firstCol[1])
        secondRow.append(secondCol[1])
        secondRow.append(thirdCol[1])

        
        thirdRow.append(firstCol[2])
        thirdRow.append(secondCol[2])
        thirdRow.append(thirdCol[2])

        return [firstRow, secondRow, thirdRow]
    }
    
    class func computeWinnings(slots: [[Slot]] ) -> (winnings: Int, matches:(flush: Int, threeOfAKind:Int, straight:Int)) {
        var slotsInRows = self.unpackSlotIntoSlotRows(slots)
        var winnings = 0
        
        var flushWinCount = 0
        var threeOfAKindCount = 0
        var straightWinCount = 0
        
        for slotRow in slotsInRows {
            if self.checkFlush(slotRow) {
                winnings += 1
                flushWinCount++
                println("Flush (\(flushWinCount))")
            }
            
            if self.checkThreeOfAKind(slotRow) {
                winnings += 5
                threeOfAKindCount++
                println("Three of a kind!")
            }
            
            if self.checkThreeInARow(slotRow) {
                winnings += 15
                straightWinCount++
                println("Three in a Row!")
            }

        }
        
        if flushWinCount == 3 {
            println("Royal Flush")
            winnings += 15
        }

        if threeOfAKindCount == 3 {
            println("Thress all around!")
            winnings += 50
        }
        
        if straightWinCount == 3 {
            println("Mega Three in a Row!!")
            winnings += 1000
        }
        
        return (winnings: winnings, matches:(flush: flushWinCount, threeOfAKind:threeOfAKindCount, straight:straightWinCount))
    }
    
    class func checkFlush(slotRow: [Slot]) -> Bool {
        
        var redCount = 0
        var blackCount = 0
        
        for slot in slotRow {
            if slot.isRed { redCount++ }
            else { blackCount++ }
        }
        return redCount == slotRow.count || blackCount == slotRow.count
        
    }
    
    class func checkThreeInARow(slotRow:[Slot]) -> Bool {
        return self.checkThreeInARowInSense(slotRow, asc: true) || self.checkThreeInARowInSense(slotRow, asc: false)
    }

    private class func checkThreeInARowInSense(slotRow:[Slot], asc:Bool) -> Bool {
        var firstValue: Int? = slotRow.first != nil ? slotRow.first!.value : nil
        
        if let fv = firstValue {
            for var i=1; i<slotRow.count; i++ {
                var matchVal:Int
                matchVal = fv - i
                if asc { matchVal = fv + i }
                if slotRow[i].value != matchVal {
                    return false
                }
            }
        } else {
            return false
        }
        return true
    }
    
    class func checkThreeOfAKind(slotRow:[Slot]) -> Bool {
        var firstValue: Int? = slotRow.first != nil ? slotRow.first!.value : nil
        
        if let fv = firstValue {
            for var i=1; i<slotRow.count; i++ {
                if slotRow[i].value != fv {
                    return false
                }
            }
        } else {
            return false
        }
        return true

    }

}