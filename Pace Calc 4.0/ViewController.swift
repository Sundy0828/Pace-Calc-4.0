//
//  ViewController.swift
//  Pace Calc 4.0
//
//  Created by Jerrod on 3/10/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var iconLoad: UIImageView!
    @IBOutlet var progressLoad: UIProgressView!
    
    @IBOutlet var distBtnView: UIView!
    @IBOutlet var timeBtnView: UIView!
    @IBOutlet var paceBtnView: UIView!
    @IBOutlet var splitBtnView: UIView!
    
    @IBOutlet var distBtnImg: UIImageView!
    @IBOutlet var timeBtnImg: UIImageView!
    @IBOutlet var paceBtnImg: UIImageView!
    @IBOutlet var splitBtnImg: UIImageView!
    
    @IBOutlet var distImgWidth: NSLayoutConstraint!
    @IBOutlet var timeImgWidth: NSLayoutConstraint!
    @IBOutlet var paceImgWidth: NSLayoutConstraint!
    @IBOutlet var splitImgWidth: NSLayoutConstraint!
    
    @IBOutlet var distBtnHeight: NSLayoutConstraint!
    @IBOutlet var timeBtnHeight: NSLayoutConstraint!
    @IBOutlet var paceBtnHeight: NSLayoutConstraint!
    @IBOutlet var splitBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var distanceHeight: NSLayoutConstraint!
    @IBOutlet weak var timeHeight: NSLayoutConstraint!
    @IBOutlet weak var paceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var distanceStack: UIStackView!
    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var paceStack: UIStackView!
    
    @IBOutlet weak var distView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var paceView: UIView!
    
    // distance label and picker
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var distancePicker: UIPickerView!
    
    // time label and picker
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    
    // pace label and picker
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var pacePicker: UIPickerView!
    
    // calculate buttons
    @IBOutlet weak var distBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var paceBtn: UIButton!
    
    // array of values for distance picker
    var distPickerOne = [String]()
    var distPickerTwo = [String]()
    var distPickerThree = [String]()
    
    // array of values for time picker
    var timePickerOne = [String]()
    var timePickerTwo = [String]()
    var timePickerThree = [String]()
    
    // connect shared functions to file
    let sharedFunc = SharedFunctions()
    
    let userSettings = UserDefaults.standard
    let keyStep = "distStepper"
    let keyDist = "distChoice"
    let keyPaceDist = "paceDistChoice"
    let keyTheme = "theme"
    let keyLapDist = "lapDist"
    
    var smallView: CGFloat = 110
    var bigView: CGFloat = 200
    
    var holdVal1 = ""
    var holdVal2 = ""
    var holdVal3 = ""
    
    // set big view height to be 35% of screen
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    
    var timer = Timer()
    
    // set all arrays
    func setArrays() {
        // put numbers 0 - 99 in for picker components
        for i in 0...99 {
            var number = String(i)
            
            // final decimal and first values for each picker go to 99 without adding zero to first 10
            distPickerOne.append(number)
            
            // make sure first decimal picker doesnt go higher than 9
            if i < 10 {
                distPickerTwo.append(number)
                distPickerThree.append(number)
                // if value has one value put a 0 in front 3 -> 03
                number = "0" + number
            }
            
            // make sure min and sec values dont go above 59
            if i < 60 {
                timePickerTwo.append(number)
                timePickerThree.append(number)
            }
            // final decimal and first values for each picker go to 99
            timePickerOne.append(number)
        }
    }
    func setView(view: UIView) {
        view.layer.cornerRadius = 50/667*height/2
        view.layer.borderWidth = 1
        if GlobalVariable.theme == "light" {
            view.layer.backgroundColor = UIColor.white.cgColor
        }else {
            view.layer.backgroundColor = GlobalVariable.silver.cgColor
        }
    }
    
    func setView2(view: UIView) {
        view.layer.cornerRadius = 50/667*height/2
        view.clipsToBounds = true
    }
    
    func setUp() {
        var tempDist : Double
        let paceTime: Double = (Double(GlobalVariable.hourP)! * 3600) + (Double(GlobalVariable.minuteP)! * 60) + (Double(GlobalVariable.secondP)!)
        if (GlobalVariable.paceDistChoice == "Mi") {
            tempDist = (1) * GlobalVariable.mile
        }else {
            tempDist = (1) / GlobalVariable.mile
        }
        if GlobalVariable.distChange == true && GlobalVariable.paceDistChange == true {
            // convert to distance of choice KM or Mi
            if sharedFunc.getDistance() > 0 {
                sharedFunc.convertDist(dist: GlobalVariable.distChoice)
            }
            
            if sharedFunc.getPace() > 0 {
                //calcuate the pace with a sub function
                let stringList : [String] = sharedFunc.calc(total: paceTime * tempDist)
                //replace text in text field with each value in array
                GlobalVariable.hourP = stringList[0]
                GlobalVariable.minuteP = stringList[1]
                GlobalVariable.secondP = stringList[2]
            }
        }else if GlobalVariable.distChange == true {
            // convert to distance of choice KM or Mi
            if sharedFunc.getDistance() > 0 {
                sharedFunc.convertDist(dist: GlobalVariable.distChoice)
            }
        }else if GlobalVariable.paceDistChange == true {
            if sharedFunc.getPace() > 0 {
                //calcuate the pace with a sub function
                
                let stringList : [String] = sharedFunc.calc(total: paceTime * tempDist)
                //replace text in text field with each value in array
                GlobalVariable.hourP = stringList[0]
                GlobalVariable.minuteP = stringList[1]
                GlobalVariable.secondP = stringList[2]
            }
        }
        
        if width < 330 {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }else {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // set view look
        setView(view: distView)
        setView(view: timeView)
        setView(view: paceView)
        
        hide()
        
        changeTheme()
        
        distBtnHeight.constant = 50/667*height
        timeBtnHeight.constant = 50/667*height
        paceBtnHeight.constant = 50/667*height
        splitBtnHeight.constant = 50/667*height
        
        setView2(view: distBtnView)
        setView2(view: timeBtnView)
        setView2(view: paceBtnView)
        setView2(view: splitBtnView)
        
        let btnHeight = 50/667*height-10
        
        distImgWidth.constant = btnHeight
        timeImgWidth.constant = btnHeight
        paceImgWidth.constant = btnHeight
        splitImgWidth.constant = btnHeight
        
        // print all the text
        printText(dText: true, tText: true, pText: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        setUp()
    }
    @objc func go() {
        progressLoad.progress += 0.001
        if progressLoad.progress == 1.0 {
            iconLoad.isHidden = true
            progressLoad.isHidden = true
            // Show the navigation bar on other view controllers
            self.navigationController?.isNavigationBarHidden = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (userSettings.value(forKey: keyDist) as! String?) != nil {
            GlobalVariable.distChoice = (userSettings.value(forKey: keyDist) as! String?)!
        }
        if (userSettings.value(forKey: keyTheme) as! String?) != nil {
            GlobalVariable.theme = (userSettings.value(forKey: keyTheme) as! String?)!
        }
        if (userSettings.value(forKey: keyLapDist) as! Double?) != nil {
            GlobalVariable.distStepperVal = (userSettings.value(forKey: keyLapDist) as! Double?)!
        }
        if (userSettings.value(forKey: keyPaceDist) as! String?) != nil {
            GlobalVariable.paceDistChoice = (userSettings.value(forKey: keyPaceDist) as! String?)!
        }
        iconLoad.isHidden = false
        progressLoad.isHidden = false
        // Hide the navigation bar on the this view controller
        self.navigationController?.isNavigationBarHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(ViewController.go), userInfo: nil, repeats: true)
        
        // set delegate and dataSource of pickers
        distancePicker.delegate = self
        distancePicker.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        pacePicker.delegate = self
        pacePicker.dataSource = self
        
        // set array values for picker views
        setArrays()
        
        setPicker()
        
        setUp()
    }
    
    func setPicker() {
        print(GlobalVariable.distanceW, GlobalVariable.distanceD1, GlobalVariable.distanceD2.prefix(1))
        distancePicker.selectRow(Int(GlobalVariable.distanceW.prefix(2))!, inComponent: 0, animated: true)
        distancePicker.selectRow(Int(GlobalVariable.distanceD1.prefix(1))!, inComponent: 1, animated: true)
        distancePicker.selectRow(Int(GlobalVariable.distanceD2.prefix(1))!, inComponent: 2, animated: true)
        
        timePicker.selectRow(Int(GlobalVariable.hourT.prefix(2))!, inComponent: 0, animated: true)
        timePicker.selectRow(Int(GlobalVariable.minuteT.prefix(2))!, inComponent: 1, animated: true)
        timePicker.selectRow(Int(Double(GlobalVariable.secondT.prefix(2))!), inComponent: 2, animated: true)
        
        pacePicker.selectRow(Int(GlobalVariable.hourP.prefix(2))!, inComponent: 0, animated: true)
        pacePicker.selectRow(Int(GlobalVariable.minuteP.prefix(2))!, inComponent: 1, animated: true)
        pacePicker.selectRow(Int(Double(GlobalVariable.secondP.prefix(2))!), inComponent: 2, animated: true)
    }
    
    // style buttons all the same
    func styleBtn(btn: UIButton) {
        //set color to blue
        let btnColor = GlobalVariable.myBlue.cgColor
        
        // use color blue and round corners
        btn.layer.backgroundColor = btnColor
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 4
    }
    func hide(sender: String = "") {
        // set big view height to be 35% of screen
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        bigView = 200/667*height
        smallView = 110/667*height
        let sizeB = CGFloat(Int(33/375*width))
        let sizeS = CGFloat(Int(19/375*width))
        let bigFont = UIFont(name: "AvenirNext-Regular", size: sizeB)
        let smallFont = UIFont(name: "AvenirNext-Regular", size: sizeS)
        
        let bigText = "Click to Edit "
        let smallText = "Calculate "
        
        // show only click here buttons
        if sender == "" {
            distBtn.setTitle(bigText + "Distance", for: .normal)
            timeBtn.setTitle(bigText + "Time", for: .normal)
            paceBtn.setTitle(bigText + "Pace", for: .normal)
            
            distancePicker.isHidden = true
            timePicker.isHidden = true
            pacePicker.isHidden = true
            
            distanceStack.axis = .vertical
            timeStack.axis = .vertical
            paceStack.axis = .vertical
            
            distanceLbl.font = bigFont
            timeLbl.font = bigFont
            paceLbl.font = bigFont
            
            distBtn.titleLabel?.font = smallFont
            timeBtn.titleLabel?.font = smallFont
            paceBtn.titleLabel?.font = smallFont
            
            distanceLbl.textAlignment = .center
            timeLbl.textAlignment = .center
            paceLbl.textAlignment = .center
            
            distanceHeight.constant = smallView
            timeHeight.constant = smallView
            paceHeight.constant = smallView
            
            distBtnImg.isHidden = false
            timeBtnImg.isHidden = false
            paceBtnImg.isHidden = false
        }else if sender == "distance" {
            distBtn.setTitle(smallText + "Distance", for: .normal)
            timeBtn.setTitle(bigText + "Time", for: .normal)
            paceBtn.setTitle(bigText + "Pace", for: .normal)
            
            distancePicker.isHidden = false
            timePicker.isHidden = true
            pacePicker.isHidden = true
            
            distanceStack.axis = .horizontal
            timeStack.axis = .vertical
            paceStack.axis = .vertical
            
            distanceLbl.font = smallFont
            timeLbl.font = bigFont
            paceLbl.font = bigFont
            
            distBtn.titleLabel?.font = smallFont
            timeBtn.titleLabel?.font = smallFont
            paceBtn.titleLabel?.font = smallFont
            
            distanceLbl.textAlignment = .right
            timeLbl.textAlignment = .center
            paceLbl.textAlignment = .center
            
            distanceHeight.constant = bigView
            timeHeight.constant = smallView
            paceHeight.constant = smallView
            
            distBtnImg.isHidden = true
            timeBtnImg.isHidden = false
            paceBtnImg.isHidden = false
        }else if sender == "time" {
            distBtn.setTitle(bigText + "Distance", for: .normal)
            timeBtn.setTitle(smallText + "Time", for: .normal)
            paceBtn.setTitle(bigText + "Pace", for: .normal)
            
            distancePicker.isHidden = true
            timePicker.isHidden = false
            pacePicker.isHidden = true
            
            distanceStack.axis = .vertical
            timeStack.axis = .horizontal
            paceStack.axis = .vertical
            
            distanceLbl.font = bigFont
            timeLbl.font = smallFont
            paceLbl.font = bigFont
            
            distBtn.titleLabel?.font = smallFont
            timeBtn.titleLabel?.font = smallFont
            paceBtn.titleLabel?.font = smallFont
            
            distanceLbl.textAlignment = .center
            timeLbl.textAlignment = .right
            paceLbl.textAlignment = .center
            
            distanceHeight.constant = smallView
            timeHeight.constant = bigView
            paceHeight.constant = smallView
            
            distBtnImg.isHidden = false
            timeBtnImg.isHidden = true
            paceBtnImg.isHidden = false
        }else if sender == "pace" {
            distBtn.setTitle(bigText + "Distance", for: .normal)
            timeBtn.setTitle(bigText + "Time", for: .normal)
            paceBtn.setTitle(smallText + "Pace", for: .normal)
            
            distancePicker.isHidden = true
            timePicker.isHidden = true
            pacePicker.isHidden = false
            
            distanceStack.axis = .vertical
            timeStack.axis = .vertical
            paceStack.axis = .horizontal
            
            distanceLbl.font = bigFont
            timeLbl.font = bigFont
            paceLbl.font = smallFont
            
            distBtn.titleLabel?.font = smallFont
            timeBtn.titleLabel?.font = smallFont
            paceBtn.titleLabel?.font = smallFont
            
            distanceLbl.textAlignment = .center
            timeLbl.textAlignment = .center
            paceLbl.textAlignment = .right
            
            distanceHeight.constant = smallView
            timeHeight.constant = smallView
            paceHeight.constant = bigView
            
            distBtnImg.isHidden = false
            timeBtnImg.isHidden = false
            paceBtnImg.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    // set views back to small
    @IBAction func hideView(_ sender: Any) {
        hide()
    }
    
    
    //calculate time button function
    @IBAction func calcTime(_ sender: Any) {
        if timePicker.isHidden {
            holdVal1 = GlobalVariable.hourT
            holdVal2 = GlobalVariable.minuteT
            holdVal3 = GlobalVariable.secondT
            hide(sender: "time")
        }else {
            //check to make sure no null fields
            if (sharedFunc.getDistance() > 0 && sharedFunc.getPace() > 0) {
                //calculate the time with a sub function
                var stringList : [String] = sharedFunc.calc(total: sharedFunc.getDistance() * sharedFunc.getPace())
                
                // make each value have 2 character values
                for i in 0...2 {
                    if stringList[i].count == 1 || Double(stringList[i])! == 0 {
                        stringList[i] = "0" + stringList[i]
                    }
                }
                if holdVal1 != stringList[0] || holdVal2 != stringList[1] || holdVal3 != stringList[2] {
                    //replace text in text field with each value in array
                    GlobalVariable.hourT = stringList[0]
                    GlobalVariable.minuteT = stringList[1]
                    GlobalVariable.secondT = stringList[2]
                    printText(tText: true)
                    setPicker()
                }
                hide()
                
            } else {
                alert(message: "value(s) for pace or distance are not greater than 0")
            }
        }
    }
    //calculate distance button function
    @IBAction func calcDist(_ sender: Any) {
        if distancePicker.isHidden {
            holdVal1 = GlobalVariable.distanceW
            holdVal2 = GlobalVariable.distanceD1
            holdVal3 = GlobalVariable.distanceD2
            hide(sender: "distance")
        }else {
            distanceCalculations()
        }
    }
    func distanceCalculations() {
        //get total time in seconds
        let time : Double = sharedFunc.getTimeSec()
        //get total pace in seconds
        let pace : Double = sharedFunc.getPace();
        //check to make sure no null fields
        if (time > 0 && pace > 0) {
            let distance = (time / pace)
            sharedFunc.setDist(dist: distance)
            if holdVal1 != GlobalVariable.distanceW || holdVal2 != GlobalVariable.distanceD1 || holdVal3 != GlobalVariable.distanceD2 {
                printText(dText: true)
            }
            hide()
            setPicker()
        } else {
            alert(message: "value(s) for time or pace are not greater than 0")
        }
    }
    //calculate pace button function
    @IBAction func calcPace(_ sender: Any) {
        if pacePicker.isHidden {
            holdVal1 = GlobalVariable.hourP
            holdVal2 = GlobalVariable.minuteP
            holdVal3 = GlobalVariable.secondP
            hide(sender: "pace")
        }else {
            paceCalulations()
        }
    }
    func paceCalulations() {
        //check to make sure no null fields
        if (sharedFunc.getDistance() > 0 && sharedFunc.getTimeSec() > 0) {
            //calcuate the pace with a sub function
            var stringList : [String] = sharedFunc.calc(total: sharedFunc.getTimeSec() / sharedFunc.getDistance())
            
            // make each value have 2 character values
            for i in 0...2 {
                if stringList[i].count == 1 || Double(stringList[i])! == 0 {
                    stringList[i] = "0" + stringList[i]
                }
            }
            if holdVal1 != stringList[0] || holdVal2 != stringList[1] || holdVal3 != stringList[2] {
                //replace text in text field with each value in array
                GlobalVariable.hourP = stringList[0]
                GlobalVariable.minuteP = stringList[1]
                GlobalVariable.secondP = stringList[2]
                printText(pText: true)
                setPicker()
            }
            hide()
            
        } else {
            alert(message: "value(s) for time or distance are not greater than 0")
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(Int(25/375*width)) + 1
    }
    // set colors for picker views
    func pickerColorChange(pickerRow: String?, time : String? = "", Dec : String? = "") -> UILabel? {
        let pickerLabel = UILabel()
        if GlobalVariable.theme == "light" {
            pickerLabel.textColor = UIColor.black
        }else {
            pickerLabel.textColor = UIColor.black
        }
        let size = CGFloat(Int(25/375*width))
        pickerLabel.text = Dec! + pickerRow! + time!
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "AvenirNext-Regular", size: size) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var returnVal =  pickerColorChange(pickerRow: "")
        if pickerView == distancePicker {
            if component == 0 {
                returnVal = pickerColorChange(pickerRow: distPickerOne[row], time: " " + GlobalVariable.distChoice)
            }else if component == 1 {
                returnVal = pickerColorChange(pickerRow: distPickerTwo[row], Dec: ".")
            }else {
                returnVal = pickerColorChange(pickerRow: distPickerThree[row])
            }
        }else {
            if component == 0 {
                returnVal = pickerColorChange(pickerRow: timePickerOne[row],time: " hr")
            }else if component == 1 {
                returnVal = pickerColorChange(pickerRow: timePickerTwo[row],time: " min")
            }else {
                returnVal = pickerColorChange(pickerRow: timePickerThree[row],time: " sec")
            }
        }
        return returnVal!
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // return 3 columns for each picker
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var returnVal = 0
        if pickerView == distancePicker {
            if component == 0 {
                returnVal = distPickerOne.count
            }else if component == 1 {
                returnVal = distPickerTwo.count
            }else {
                returnVal = distPickerThree.count
            }
        }else{
            if component == 0 {
                returnVal = timePickerOne.count
            }else if component == 1 {
                returnVal = timePickerTwo.count
            }else {
                return timePickerThree.count
            }
        }
        return returnVal
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var returnVal = ""
        if pickerView == distancePicker {
            if component == 0 {
                returnVal = distPickerOne[row]
            }else if component == 1 {
                returnVal = distPickerTwo[row]
            }else {
                returnVal = distPickerThree[row]
            }
        }else {
            if component == 0 {
                returnVal = timePickerOne[row]
            }else if component == 1 {
                returnVal = timePickerTwo[row]
            }else {
                returnVal = timePickerThree[row]
            }
        }
        return returnVal
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedOne, selectedTwo, selectedThree : Int
        var one, two, three : String
        
        // if distance picker set values for distance label
        if pickerView == distancePicker {
            //get row selected
            selectedOne = distancePicker.selectedRow(inComponent: 0)
            selectedTwo = distancePicker.selectedRow(inComponent: 1)
            selectedThree = distancePicker.selectedRow(inComponent: 2)
            
            //use row selected to find final value
            one = distPickerOne[selectedOne]
            two = distPickerTwo[selectedTwo]
            three = distPickerThree[selectedThree]
            
            //set values
            GlobalVariable.distanceW = one
            GlobalVariable.distanceD1 = two
            GlobalVariable.distanceD2 = three
            
            //print
            printText(dText: true)
            // if time picker set values for time label
        }else if pickerView == timePicker {
            //get row selected
            selectedOne = timePicker.selectedRow(inComponent: 0)
            selectedTwo = timePicker.selectedRow(inComponent: 1)
            selectedThree = timePicker.selectedRow(inComponent: 2)
            
            //use row selected to find final value
            one = timePickerOne[selectedOne]
            two = timePickerTwo[selectedTwo]
            three = timePickerThree[selectedThree]
            
            // set values
            GlobalVariable.hourT = one
            GlobalVariable.minuteT = two
            GlobalVariable.secondT = three
            
            // print
            printText(tText: true)
            //if pace picker set values for pace label
        }else {
            // get row selected
            selectedOne = pacePicker.selectedRow(inComponent: 0)
            selectedTwo = pacePicker.selectedRow(inComponent: 1)
            selectedThree = pacePicker.selectedRow(inComponent: 2)
            
            //use row selected to find final value
            one = timePickerOne[selectedOne]
            two = timePickerTwo[selectedTwo]
            three = timePickerThree[selectedThree]
            
            // set values
            GlobalVariable.hourP = one
            GlobalVariable.minuteP = two
            GlobalVariable.secondP = three
            
            //print
            printText(pText: true)
        }
    }
    
    //function to print instead of typing it all the time
    func printText(dText: Bool? = false, tText: Bool? = false, pText: Bool? = false) {
        var hold = ""
        var one, two, three : String
        // print distance
        if dText == true {
            one = String(GlobalVariable.distanceW)
            two = String(GlobalVariable.distanceD1)
            three = String(GlobalVariable.distanceD2)
            if one.count < 1 {one = "0" + one}
            hold = "\(one).\(two)\(three.prefix(1)) \(GlobalVariable.distChoice)"
            distanceLbl.text = hold
            //bigDistBtn.setTitle(hold, for: .normal)
        }
        //print time
        if tText == true {
            one = String(GlobalVariable.hourT)
            two = String(GlobalVariable.minuteT)
            three = String(GlobalVariable.secondT)
            if one.count <= 1 {one = "0" + one}
            if two.count <= 1 {two = "0" + two}
            if three.prefix(2).contains(".") {three = "0" + GlobalVariable.secondT}
            if three == "000" {three = "00"}
            hold = "\(one):\(two):\(three.prefix(4))"
            timeLbl.text = hold
            //bigTimeBtn.setTitle(hold, for: .normal)
        }
        //print pace
        if pText == true {
            one = String(GlobalVariable.hourP)
            two = String(GlobalVariable.minuteP)
            three = String(GlobalVariable.secondP)
            if one.count <= 1 {one = "0" + one}
            if two.count <= 1 {two = "0" + two}
            if three.prefix(2).contains(".") {three = "0" + GlobalVariable.secondP}
            if three == "000" {three = "00"}
            print(GlobalVariable.paceDistChoice)
            hold = "\(one):\(two):\(three.prefix(4)) /\(GlobalVariable.paceDistChoice)"
            paceLbl.text = hold
            //bigPaceBtn.setTitle(hold, for: .normal)
        }
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
    // change color scheme
    func changeTheme() {
        var textColor : UIColor
        var bgColor: UIColor
        // set colors
        if GlobalVariable.theme == "dark" {
            bgColor = UIColor.darkGray
            textColor = .black
            //navigationController?.navigationBar.barStyle = .black
        }else {
            bgColor = GlobalVariable.silver
            textColor = .black
            //navigationController?.navigationBar.barStyle = .default
        }
        //set colors to items
        distanceLbl.textColor = textColor
        timeLbl.textColor = textColor
        paceLbl.textColor = textColor
        self.view.backgroundColor = bgColor
        
        
    }
    func themeBtn(button: UIButton, textColor: UIColor) {
        button.setTitleColor(textColor, for: .normal)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
    }


}

