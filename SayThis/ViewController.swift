//
//  ViewController.swift
//  SayThis
//
//  Created by Doyle, Mark(Information Technology Services) on 11/29/18.
//  Copyright © 2018 Doyle, Mark(Information Technology Services). All rights reserved.
//

import Cocoa

//Get UserName
let userName = NSUserName()

//Get Full UserName
let fullUserName = NSFullUserName()

//Some Departmartments for the naming app
var department: [String] = ["ACCS", "ACCT", "ADAF", "ADMN", "ADVC", "ASCI", "ATHL", "BIOL", "BOOK", "BUAD", "CARD", "CECE", "CEDU", "CFDC", "COMM", "COUN", "ECON", "EDUC", "ENGL"]

// Fetch the computers serial number...
let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice") )
    

let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue()).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)





class ViewController: NSViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    //Reminder that tells you how smart you are using SAY from bash....
    @IBOutlet weak var reminderProgress: NSProgressIndicator!
    @IBAction func talk(_ sender: NSButtonCell) {
        let path = "/usr/bin/say"
        let arguments = ["\(fullUserName) You are a super genius, keep up the good work."]
        sender.isEnabled = false
        reminderProgress.startAnimation(self)
        let task = Process.launchedProcess(launchPath: path, arguments: arguments)
        task.waitUntilExit()
        sender.isEnabled = true
        reminderProgress.stopAnimation(self)
    }
 
    
    
    
    // This Function will say the computers serial #
    @IBOutlet weak var saySerial: NSProgressIndicator!
    @IBAction func saySerial(_ sender: NSButton) {
        
        let path = "/usr/bin/say"
        let arguments = ["Your computers serial number is", serialNumber]
        sender.isEnabled = false
        saySerial.startAnimation(self)
        let task = Process.launchedProcess(launchPath: path, arguments: arguments as! [String] )
        task.waitUntilExit()
        sender.isEnabled = true
        saySerial.stopAnimation(self)
    }
    
    
    // This Function willl say what you tell it!
    @IBOutlet weak var sayThisTextField: NSTextField!
    @IBOutlet weak var sayProgress: NSProgressIndicator!
    @IBOutlet weak var voicePopup: NSPopUpButton!
  
    @IBAction func sayThis(_ sender: NSButton) {
        let path = "/usr/bin/say"
        let textToSay = sayThisTextField.stringValue
        var arguments = [textToSay]
        if let voice = voicePopup.titleOfSelectedItem {
            arguments += ["-v",voice]
        }
        sender.isEnabled = false
        sayProgress.startAnimation(self)
        let task = Process.launchedProcess(launchPath: path, arguments: arguments as! [String] )
        task.waitUntilExit()
        sender.isEnabled = true
        sayProgress.stopAnimation(self)
    }
    
    
    
    
   
    // This function sends the ls -l command to a window on the app
    @IBOutlet var dsktopText: NSTextView!
    @IBAction func dskFiles(_ sender: NSButton) {
        let task = Process()
        task.launchPath = "/bin/ls"
        task.arguments = ["-l"]
       
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        let directory = output!
       
        dsktopText.textStorage?.append(NSAttributedString(string: directory as String))
        print(directory)
    }


//This function pulls the last six digits of the computers serial #
    @IBOutlet weak var computerName: NSTextField!
    @IBAction func Serial(_ sender: NSButton) {

        let serialEnd = serialNumber.endIndex
        let serialStart = serialNumber.index(serialEnd, offsetBy: -6)
        let range = Range(uncheckedBounds: (lower: serialStart, upper: serialEnd))
        let lastSix = serialNumber[range]
        dsktopText.textStorage?.append(NSAttributedString(string: lastSix+"\n" as String))
        computerName.stringValue = "E"+department[0]+lastSix
    }
  
   
}

