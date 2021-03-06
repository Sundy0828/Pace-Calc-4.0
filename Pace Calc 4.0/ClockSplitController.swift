//
//  ClockSplitController.swift
//  Pace Calc 4.0
//
//  Created by Jerrod on 7/11/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import Foundation
import UIKit

class ClockSplitController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // set base values for distance, distance in meeters, default lap split value, stepper value, and lap num
    let distance = GlobalVariable.distanceW + "." + GlobalVariable.distanceD1 + GlobalVariable.distanceD2
    var distanceM : Double = 0.0
    var distStepperVal = 200.0
    var distStepper = 100.0
    var lapNum : Double = 0.0
    
    // arrays for table
    var lapArr : [String] = []
    var timeArr : [String] = []
    var lapTimeArr : [String] = []
    var comboArr = ""
    
    // Timer variables
    var stopWatch = Timer()
    var currentTime = 0
    var isRunning = true
    
    @IBOutlet var tableView: UITableView!
    
    // timer outlets
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var lapBtn: UIButton!
    
    let sharedFunc = SharedFunctions()
    
    // set big view height to be 35% of screen
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    
    // combine two arrays into one string
    func combineArrays(arrayOne : [String], arrayTwo : [String]) {
        comboArr.removeAll()
        if (!arrayTwo.isEmpty && !arrayOne.isEmpty) {
            // for every value in arrays which are equal in length add them to a string
            var totRow = 0
            if lapTimeArr.count > arrayOne.count {
                totRow = lapTimeArr.count
            }else {
                totRow = arrayOne.count
            }
            for i in 0...totRow - 1 {
                
                var itemOne = ""
                var itemTwo = ""
                var itemThree = ""
                
                if lapTimeArr.count <= i {
                    itemOne = lapTimeArr[i]
                }
                if arrayOne.count <= i {
                    itemTwo = arrayOne[i]
                }
                if arrayTwo.count <= i {
                    itemThree = arrayTwo[i]
                }
                
                // determine if its on the last one
                if i != totRow - 1 {
                    // string + lap # (distance) + some spaces + lap time + new line
                    comboArr = itemOne + " " + itemTwo + "  " + itemThree + "\n"
                }else {
                    // string + lap # (distance) + some spaces + lap time but no new line for last one
                    comboArr = itemOne + " " + itemTwo + "  " + itemThree
                }
            }
        }
    }
    
    // share button was tapped
    @IBAction func shareTapped(_ sender: Any) {
        // combine arrays into string
        combineArrays(arrayOne: lapArr, arrayTwo: timeArr)
        // create popup for share
        let activityVC = UIActivityViewController(activityItems: [comboArr], applicationActivities: nil)
        // set popup to view
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // present share view
        self.present(activityVC, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        changeTheme()
        self.navigationController?.navigationBar.topItem?.title = "Clock Lap Split"
        
        // set tables items to self
        tableView.delegate = self
        tableView.dataSource = self
        
        // get distance in meters depending on selected distance
        if GlobalVariable.distChoice == "KM" {
            //convert KM to meter
            distanceM  = Double(distance)! * 1000
        }else {
            // convert mile to KM then to meter
            distanceM = Double(distance)! * GlobalVariable.mile * 1000
        }
        
        lapSplit()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Clock Lap Split"
        changeTheme()
        
        // set tables items to self
        tableView.delegate = self
        tableView.dataSource = self
        
        // get distance in meters depending on selected distance
        if GlobalVariable.distChoice == "KM" {
            //convert KM to meter
            distanceM  = Double(distance)! * 1000
        }else {
            // convert mile to KM then to meter
            distanceM = Double(distance)! * GlobalVariable.mile * 1000
        }
        
        lapSplit()
        
    }
    
    
    @IBAction func startPressed(_ sender: Any) {
        if (isRunning) {
            stopWatch = Timer.scheduledTimer(timeInterval: 0.00000001, target: self, selector: (#selector(ClockSplitController.UpdateTime)), userInfo: nil, repeats: true)
            isRunning = !isRunning
            startBtn.setTitle("Stop", for: .normal)
            lapBtn.setTitle("Lap", for: .normal)
        }else {
            stopWatch.invalidate()
            isRunning = !isRunning
            startBtn.setTitle("Start", for: .normal)
            lapBtn.setTitle("Reset", for: .normal)
        }
    }
    @IBAction func lapPressed(_ sender: Any) {
        if lapBtn.titleLabel?.text != "Reset" {
            lapTimeArr.append(getLapTime())
        }else {
            var hold : [String] = []
            for i in 0...lapArr.count {
                hold.append("00:00:00.0")
            }
            lapTimeArr = hold
            timerLbl.text = "00:00:00.0"
        }
        tableView.reloadData()
        
    }
    @objc func UpdateTime() {
        currentTime += 1
        
        timerLbl.text = getLapTime()
    }
    
    func addZero(value : Int) -> String {
        var zero = ""
        if value < 10 {
            zero = "0"
        }
        return zero + "\(value)"
    }
    
    func getLapTime() -> String {
        let mili = currentTime % 10
        let sec = currentTime / 10 % 60
        let min = (currentTime / 10 / 60) % 60
        let hour = (currentTime / 10 / 3600)
        
        return "\(addZero(value: hour)):\(addZero(value: min)):\(addZero(value: sec)).\(mili)"
    }
    
    
    func lapSplit() {
        // set label for lap distance
        // if distance if more than 0 and more than lap distance then find number of laps
        if distanceM > 0 && distanceM >= GlobalVariable.distStepperVal {
            lapNum = distanceM / GlobalVariable.distStepperVal
            // if greater than 0  but less than value set lap number to 1
        }else if distanceM > 0 && distanceM < GlobalVariable.distStepperVal {
            lapNum = 1
        }
        setTable()
        self.tableView.reloadData()
    }
    
    
    
    // sets values for UITable
    func setTable() {
        // if distance is more than 0 then there will be laps
        if sharedFunc.getDistance() > 0 {
            // clear old values in arrays
            lapArr.removeAll()
            timeArr.removeAll()
            
            // create default string for fetching the times
            var StringArray = [String]()
            // if lap number rounded up is more than one then there will be more than 1 lap
            if lapNum.rounded(.up) > 1 {
                
                // loop through the number of laps
                for i in 1...Int(lapNum.rounded(.down)) {
                    // set lap dist = lap dist * current lap and add it to the array
                    let lapDist = GlobalVariable.distStepperVal * Double(i)
                    lapArr.append("Lap - \(i) (\(Int(lapDist))m)")
                    
                    //get the three time values
                    // time per lap tot sec / distance * lap dist * current lap #
                    StringArray = sharedFunc.calc(total: sharedFunc.getTimeSec() / distanceM * GlobalVariable.distStepperVal * Double(i))
                    // add a 0 infront of string if it only has one value ex. 3 -> 03
                    for i in 0...2 {
                        if String(Int(Double(StringArray[i])!)).count == 1 || Int(Double(StringArray[i])!) == 0 {
                            StringArray[i] = "0" + StringArray[i]
                        }
                    }
                    // add time to the time array
                    timeArr.append("\(StringArray[0]):\(StringArray[1]):\(StringArray[2].prefix(4))")
                }
            }
            // check if only 1 lap
            if lapNum.rounded(.down) < lapNum.rounded(.up) || lapNum.rounded(.up) == 1{
                // set lap dist and add to array
                lapArr.append("lap - \(Int(lapNum.rounded(.up))) (\(Int(distanceM)))")
                
                // get entire time value since only one lap
                StringArray = sharedFunc.calc(total: sharedFunc.getTimeSec())
                // add a 0 infront of string if it only has one value ex. 3 -> 03
                for i in 0...2 {
                    if StringArray[i].count == 1 || Double(StringArray[i])! == 0 {
                        StringArray[i] = "0" + StringArray[i]
                    }
                }
                // add time to the array
                timeArr.append("\(StringArray[0]):\(StringArray[1]):\(StringArray[2].prefix(4))")
            }
        }
    }
    // set labels in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clockSplitCell") as! CustomClockTableViewCell
        if GlobalVariable.theme == "dark" {
            tableView.backgroundColor = UIColor.darkGray
            cell.backgroundColor = UIColor.darkGray
            cell.lapLbl.textColor = UIColor.white
            cell.timeLbl.textColor = UIColor.white
            cell.diffTimeLbl.textColor = UIColor.white
        }else {
            tableView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            cell.lapLbl.textColor = UIColor.black
            cell.timeLbl.textColor = UIColor.black
            cell.diffTimeLbl.textColor = UIColor.black
        }
        let sizeB = CGFloat(Int(17/375*width))
        let bigFont = UIFont(name: "AvenirNext-Regular", size: sizeB)
        
        if lapArr.count > indexPath.row {
            cell.lapLbl.text = lapArr[indexPath.row]
        }
        if lapTimeArr.count > indexPath.row {
            cell.timeLbl.text = lapTimeArr[indexPath.row]
        }
        if timeArr.count > indexPath.row {
            cell.diffTimeLbl.text = timeArr[indexPath.row]
        }
        
        cell.lapLbl.font = bigFont
        cell.timeLbl.font = bigFont
        cell.diffTimeLbl.font = bigFont
        return cell
    }
    // set number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(lapNum.rounded(.up))
    }
    
    
    
    // alert function
    func alert(message: String, title: String = "Error") {
        //calls alert controller with tital and message
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //creates and adds ok button
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        //shows
        self.present(alertController, animated: true, completion: nil)
    }
    func changeTheme() {
        if GlobalVariable.theme == "dark" {
            self.view.backgroundColor = UIColor.darkGray
        }else {
            self.view.backgroundColor = GlobalVariable.silver
        }
    }
}

