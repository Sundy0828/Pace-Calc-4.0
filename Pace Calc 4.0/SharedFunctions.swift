//
//  SharedFunctions.swift
//  Pace Calc 4.0
//
//  Created by Jerrod on 3/11/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

struct GlobalVariable{
    static var distanceW: String = "00"
    static var distanceD1: String = "0"
    static var distanceD2: String = "000"
    
    static var hourT: String = "00"
    static var minuteT: String = "00"
    static var secondT: String = "00"
    
    static var hourP: String = "00"
    static var minuteP: String = "00"
    static var secondP: String = "00"
    
    static var distChoice: String = "KM"
    static var paceDistChoice: String = "KM"
    static var distStepperVal = 200.0
    
    static var mile: Double = 1.609344
    
    static let myBlue = UIColor(red: 51/255, green: 161/255, blue: 252/255, alpha: 1.0)
    static let silver = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
    static var theme: String = "dark"
    
    static var distChange: Bool = false
    static var paceDistChange: Bool = false
    
}

class SharedFunctions: NSObject {
    // convert double to string without losing decimal places
    func convertToString(num : Double) -> String {
        return String(format: "%.64f", num)
    }
    //convert substring to string without losing decimal places
    func convertToStrings(val : Substring) -> String {
        return String(format: "%.64f", val as CVarArg)
    }
    
    // set distance fields
    func setDist(dist : Double) {
        var distance = dist
        // set whole number to distance as an int rounded down
        GlobalVariable.distanceW = String(Int(distance.rounded(.down)))
        
        //if distance is not 0 then find the rest of the values
        if distance != 0 {
            //reduce distance so that the whole number doesnt show
            distance = distance - distance.rounded(.down)
            
            // conver to string, but without losing decimals
            let distHold = convertToString(num: distance)
            // get all values of string except first two
            var holder = distHold.suffix(distHold.count - 2)
            // get first number after decimal
            GlobalVariable.distanceD1 = String(holder.prefix(1))
            // get all values except first 3, not repeating that first one for distanceD1
            holder = holder.suffix(distHold.count - 3)
            
            // if holder is not null then set value otherwise make it 000
            if holder != "" {
                GlobalVariable.distanceD2 = String(holder)
            }else {
                GlobalVariable.distanceD2 = "000"
            }
            //if distance == 0 then set D1 and D2 to 0's
        }else {
            GlobalVariable.distanceD1 = "0"
            GlobalVariable.distanceD2 = "000"
        }
    }
    
    // converts distance to KM or MI
    func convertDist(dist : String) {
        // set distan
        var distance = Double(GlobalVariable.distanceW + "." + GlobalVariable.distanceD1 + GlobalVariable.distanceD2)!
        
        // determine whether user wants KM or MI
        if dist == "KM" {
            distance = distance * GlobalVariable.mile
        }else {
            distance = distance / GlobalVariable.mile
        }
        
        // set whole number to distance as an int rounded down
        GlobalVariable.distanceW = String(Int(distance.rounded(.down)))
        
        //if distance is not 0 then find the rest of the values
        if distance != 0 {
            //reduce distance so that the whole number doesnt show
            distance = distance - distance.rounded(.down)
            
            // conver to string, but without losing decimals
            let distHold = convertToString(num: distance)
            // get all values of string except first two
            var holder = distHold.suffix(distHold.count - 2)
            // get first number after decimal
            GlobalVariable.distanceD1 = String(holder.prefix(1))
            // get all values except first 3, not repeating that first one for distanceD1
            holder = holder.suffix(distHold.count - 3)
            
            // if holder is not null then set value otherwise make it 000
            if holder != "" {
                GlobalVariable.distanceD2 = String(holder)
            }else {
                GlobalVariable.distanceD2 = "000"
            }
            //if distance == 0 then set D1 and D2 to 0's
        }else {
            GlobalVariable.distanceD1 = "0"
            GlobalVariable.distanceD2 = "000"
        }
    }
    
    //get total time in seconds
    func getTimeSec() -> Double {
        //if at least one value is not null then convert time to time in seconds
        if (GlobalVariable.hourT != "" || GlobalVariable.minuteT != "" || GlobalVariable.secondT != "") {
            return (Double(GlobalVariable.hourT)! * 3600) + (Double(GlobalVariable.minuteT)! * 60) + (Double(GlobalVariable.secondT)!)
        }else {
            return -1
        }
    }
    //convert distance to double
    func getDistance() -> Double {
        //if at least one value is not null then convert distance to distance put together as double
        if (GlobalVariable.distanceW != "" || GlobalVariable.distanceD1 != "" || GlobalVariable.distanceD2 != "") {
            if (GlobalVariable.paceDistChoice == GlobalVariable.distChoice) {
                return (Double(GlobalVariable.distanceW + "." + GlobalVariable.distanceD1 + GlobalVariable.distanceD2)!)
            }else {
                if (GlobalVariable.paceDistChoice == "KM") {
                    return (Double(GlobalVariable.distanceW + "." + GlobalVariable.distanceD1 + GlobalVariable.distanceD2)!) * GlobalVariable.mile
                }else {
                    return (Double(GlobalVariable.distanceW + "." + GlobalVariable.distanceD1 + GlobalVariable.distanceD2)!) / GlobalVariable.mile
                }
            }
        }else {
            return -1
        }
    }
    //calculate total pace in seconds
    func getPace() -> Double {
        var paceTime: Double = (Double(GlobalVariable.hourP)! * 3600) + (Double(GlobalVariable.minuteP)! * 60) + (Double(GlobalVariable.secondP)!)
        //if at least one value is not null then convert pace to time in seconds
        if (GlobalVariable.hourP != "" || GlobalVariable.minuteP != "" || GlobalVariable.secondP != "") {
            if (GlobalVariable.paceDistChoice == GlobalVariable.distChoice) {
                return paceTime
            }else {
                if (GlobalVariable.distChoice == "KM") {
                    return paceTime / GlobalVariable.mile
                }else {
                    return paceTime * GlobalVariable.mile
                }
            }
            
        }else {
            return -1
        }
    }
    
    func calc(total : Double) -> Array<String> {
        //hour, minute, second, and temporary holder values
        var hour: Int = 0
        var minute: Int = 0
        var second: Double = 0
        var temp : Double = total
        //if number is bigger than 3600 then it is in the hours
        if (temp >= 3600) {
            //so divide by 3600 and truncate by converting to int
            hour = Int(temp / 3600)
            //get the mod of total so you can go down the line
            //you do this because you could just subtract the truncated value from total and multiply by 3600
            //but that is extra steps
            temp = temp.truncatingRemainder(dividingBy: 3600)
        }
        //if bigger than 60 than in minutes
        if (temp >= 60) {
            //so divide by 60 and truncate by converting to int
            minute = Int(temp / 60)
            //get the mod of smaller total so you can contine
            temp = temp.truncatingRemainder(dividingBy: 60)
        }
        //has to be smaller than 60 at this point
        if (temp < 60) {
            second = temp
        }
        
        //return hours, minutes, and seconds all at once
        return [String(hour), String(minute), String(second)]
    }
}
