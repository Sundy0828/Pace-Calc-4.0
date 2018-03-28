//
//  SettingsController.swift
//  Pace Calc 4.0
//
//  Created by Jerrod on 3/11/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit
class SettingsController: UITableViewController {
    let userSettings = UserDefaults.standard
    var distStepper = 100.0
    var btnTagClicked = 4
    let keyDist = "distChoice"
    let keyPaceDist = "paceDistChoice"
    let keyTheme = "theme"
    let keyLapDist = "lapDist"
    var timer: Timer!
    var timerOne: Timer!
    
    var textArr = ["Track Size", "Distance Units", "Pace Distance Units", "Theme"]
    var imgArrL = [#imageLiteral(resourceName: "blackTrack"),#imageLiteral(resourceName: "blackTrack"),#imageLiteral(resourceName: "blackClockPace"),#imageLiteral(resourceName: "blackSun")]
    var imgArrD = [#imageLiteral(resourceName: "blackTrack"),#imageLiteral(resourceName: "blackTrack"),#imageLiteral(resourceName: "blackClockPace"),#imageLiteral(resourceName: "blackMoon")]
    
    @IBOutlet var distKMImg: UIImageView!
    @IBOutlet var distMIImg: UIImageView!
    @IBOutlet var paceDistKMImg: UIImageView!
    @IBOutlet var paceDistMIImg: UIImageView!
    @IBOutlet var litImg: UIImageView!
    @IBOutlet var darkImg: UIImageView!
    
    @IBOutlet var arrowImg: UIImageView!
    
    @IBOutlet weak var trackSizeLbl: UILabel!
    @IBOutlet var kiloDULbl: UILabel!
    @IBOutlet var mileDULbl: UILabel!
    @IBOutlet var kiloPDULbl: UILabel!
    @IBOutlet var milePDULbl: UILabel!
    @IBOutlet var lThemeLbl: UILabel!
    @IBOutlet var dThemeLbl: UILabel!
    
    @IBOutlet weak var trackSize: UITableViewCell!
    @IBOutlet weak var kiloDU: UITableViewCell!
    @IBOutlet weak var mileDU: UITableViewCell!
    @IBOutlet weak var kiloPDU: UITableViewCell!
    @IBOutlet weak var milePDU: UITableViewCell!
    @IBOutlet weak var lTheme: UITableViewCell!
    @IBOutlet weak var dTheme: UITableViewCell!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        GlobalVariable.distChange = false
        GlobalVariable.paceDistChange = false
        
        style()
        changeTheme()
        
        trackSizeLbl.text = "\(GlobalVariable.distStepperVal) meters"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalVariable.distChange = false
        GlobalVariable.paceDistChange = false
        
        style()
        changeTheme()
        
        trackSizeLbl.text = "\(GlobalVariable.distStepperVal) meters"
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.tableHeaderView?.frame.size.height = 45
        
        let view = UIView()
        
        let image = UIImageView()
        image.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        
        let label = UILabel()
        label.text = textArr[section]
        label.frame = CGRect(x: 30, y: 5, width: 250, height: 20)
        
        if GlobalVariable.theme == "light" {
            image.image = imgArrL[section]
            view.backgroundColor = UIColor.white
            label.textColor = UIColor.black
        }else {
            image.image = imgArrD[section]
            view.backgroundColor = GlobalVariable.silver
            label.textColor = UIColor.black
        }
        
        view.addSubview(image)
        view.addSubview(label)
        
        return view
    }
    /*override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        if GlobalVariable.theme == "light" {
            view.tintColor = UIColor.white
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.black
        }else {
            view.tintColor = GlobalVariable.silver
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
        }
    }*/
    func style() {
        
        if GlobalVariable.distChoice == "Mi" {
            kiloDU.accessoryType = .none
            mileDU.accessoryType = .checkmark
        }else {
            kiloDU.accessoryType = .checkmark
            mileDU.accessoryType = .none
        }
        if GlobalVariable.paceDistChoice == "Mi" {
            kiloPDU.accessoryType = .none
            milePDU.accessoryType = .checkmark
        }else {
            kiloPDU.accessoryType = .checkmark
            milePDU.accessoryType = .none
        }
        if GlobalVariable.theme == "dark" {
            lTheme.accessoryType = .none
            dTheme.accessoryType = .checkmark
        }else {
            lTheme.accessoryType = .checkmark
            dTheme.accessoryType = .none
        }
        trackSizeLbl.text = "\(GlobalVariable.distStepperVal) meters"
        changeTheme()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Your action here
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 1 {
            if row == 0 {
                GlobalVariable.distChoice = "KM"
                userSettings.set(GlobalVariable.distChoice, forKey: keyDist)
            }else if row == 1 {
                GlobalVariable.distChoice = "Mi"
                userSettings.set(GlobalVariable.distChoice, forKey: keyDist)
            }
            GlobalVariable.distChange = true
        }else if section == 2 {
            if row == 0 {
                GlobalVariable.paceDistChoice = "KM"
                userSettings.set(GlobalVariable.paceDistChoice, forKey: keyPaceDist)
            }else if row == 1 {
                GlobalVariable.paceDistChoice = "Mi"
                userSettings.set(GlobalVariable.paceDistChoice, forKey: keyPaceDist)
            }
            GlobalVariable.paceDistChange = true
        }else if section == 3 {
            if row == 0 {
                GlobalVariable.theme = "light"
                userSettings.set(GlobalVariable.theme, forKey: keyTheme)
                //navigationController?.navigationBar.barStyle = .default
            }else if row == 1 {
                GlobalVariable.theme = "dark"
                userSettings.set(GlobalVariable.theme, forKey: keyTheme)
                //navigationController?.navigationBar.barStyle = .black
            }
            changeTheme()
        }
        style()
    }
    func changeTheme() {
        var cellColor: UIColor = .darkGray
        var cellTextColor: UIColor = .black
        var imageK: UIImage = UIImage(named: "blackKM")!
        var imageD: UIImage = UIImage(named: "blackMoon")!
        var imageL: UIImage = UIImage(named: "blackSun")!
        var imageM: UIImage = UIImage(named: "blackMI")!
        var image: UIImage = UIImage(named: "blackArrow")!
        if GlobalVariable.theme == "light" {
            cellColor = GlobalVariable.silver
        }else {
            cellTextColor = .white
            image = UIImage(named: "whiteArrow")!
            imageK = UIImage(named: "whiteKM")!
            imageM = UIImage(named: "whiteMI")!
            imageD = UIImage(named: "whiteMoon")!
            imageL = UIImage(named: "whiteSun")!
        }
        arrowImg.image = image
        distKMImg.image = imageK
        paceDistKMImg.image = imageK
        distMIImg.image = imageM
        paceDistMIImg.image = imageM
        darkImg.image = imageD
        litImg.image = imageL
        
        trackSizeLbl.textColor = cellTextColor
        kiloDULbl.textColor = cellTextColor
        mileDULbl.textColor = cellTextColor
        kiloPDULbl.textColor = cellTextColor
        milePDULbl.textColor = cellTextColor
        lThemeLbl.textColor = cellTextColor
        dThemeLbl.textColor = cellTextColor
        
        trackSize.tintColor = cellTextColor
        kiloDU.tintColor = cellTextColor
        mileDU.tintColor = cellTextColor
        kiloPDU.tintColor = cellTextColor
        milePDU.tintColor = cellTextColor
        lTheme.tintColor = cellTextColor
        dTheme.tintColor = cellTextColor
        
        trackSize.backgroundColor = cellColor
        kiloDU.backgroundColor = cellColor
        mileDU.backgroundColor = cellColor
        kiloPDU.backgroundColor = cellColor
        milePDU.backgroundColor = cellColor
        lTheme.backgroundColor = cellColor
        dTheme.backgroundColor = cellColor
        view.backgroundColor = cellColor
        tableView.reloadData()
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        // Declare Alert
        let dialogMessage = UIAlertController(title: "Reset", message: "Are you sure you want to reset the settings?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            GlobalVariable.distChoice = "KM"
            self.userSettings.set(GlobalVariable.distChoice, forKey: self.keyDist)
            GlobalVariable.paceDistChoice = "KM"
            self.userSettings.set(GlobalVariable.paceDistChoice, forKey: self.keyPaceDist)
            GlobalVariable.theme = "light"
            self.userSettings.set(GlobalVariable.theme, forKey: self.keyTheme)
            GlobalVariable.distStepperVal = 200.0
            self.userSettings.set(GlobalVariable.distStepperVal, forKey: self.keyLapDist)
            
            self.style()
            self.changeTheme()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // event if canceled
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
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
}
