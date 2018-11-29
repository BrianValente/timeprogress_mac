//
//  ViewController.swift
//  Time Progress
//
//  Created by Brian Valente on 11/19/18.
//  Copyright © 2018 Brian Valente. All rights reserved.
//

import Cocoa

import LoginServiceKit

class Preferences: NSViewController, NSControlTextEditingDelegate, NSDatePickerCellDelegate {
    
    @IBOutlet weak var twitterButton: NSButtonLabel!
    @IBOutlet weak var githubButton: NSButtonLabel!
    
    @IBOutlet weak var red: NSButton!
    @IBOutlet weak var green: NSButton!
    @IBOutlet weak var blue: NSButton!
    @IBOutlet weak var yellow: NSButton!
    @IBOutlet weak var orange: NSButton!
    @IBOutlet weak var purple: NSButton!
    @IBOutlet weak var white: NSButton!
    @IBOutlet weak var gray: NSButton!
    @IBOutlet weak var black: NSButton!
    
    @IBOutlet weak var launchAtLogin: NSButton!
    
    @IBOutlet weak var customDeadlineName: NSTextField!
    @IBOutlet weak var customDeadlineTimeFrom: NSDatePicker!
    @IBOutlet weak var customDeadlineTimeTo: NSDatePicker!
    
    @IBOutlet weak var progressBarVisible: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewController loaded!!")
        
        let twitterGesture = NSClickGestureRecognizer()
        twitterGesture.buttonMask = 0x1 // left mouse
        twitterGesture.numberOfClicksRequired = 1
        twitterGesture.target = self
        twitterGesture.action = #selector(openTwitterProfile)
        
        twitterButton.addGestureRecognizer(twitterGesture)
        
        let githubGesture = NSClickGestureRecognizer()
        githubGesture.buttonMask = 0x1 // left mouse
        githubGesture.numberOfClicksRequired = 1
        githubGesture.target = self
        githubGesture.action = #selector(openGithub)
        
        githubButton.addGestureRecognizer(githubGesture)
        
        switch AppDelegate.shared?.getProgressBarColorName() {
        case "red":
            red.state = NSControl.StateValue.on
        case "green":
            green.state = NSControl.StateValue.on
        case "blue":
            blue.state = NSControl.StateValue.on
        case "yellow":
            yellow.state = NSControl.StateValue.on
        case "orange":
            orange.state = NSControl.StateValue.on
        case "purple":
            purple.state = NSControl.StateValue.on
        case "white":
            white.state = NSControl.StateValue.on
        case "gray":
            gray.state = NSControl.StateValue.on
        case "black":
            black.state = NSControl.StateValue.on
        default:
            break
        }
        
        launchAtLogin.state = LoginServiceKit.isExistLoginItems() ? .on : .off
        
        progressBarVisible.state = AppDelegate.shared!.getProgressBarVisibility() ? .on : .off
        
        initCustomDeadline()
    }
    
    func initCustomDeadline() {
        customDeadlineName.stringValue = CustomDeadline.name
        //customDeadlineTimeFrom.stringValue = (AppDelegate.shared?.getCustomDeadlineTimeFrom())!
        //customDeadlineTimeTo.stringValue = (AppDelegate.shared?.getCustomDeadlineTimeTo())!
        
        guard
            let from = CustomDeadline.from,
            let to = CustomDeadline.to
            else {
                return
        }
        
        customDeadlineTimeFrom.dateValue = from
        customDeadlineTimeTo.dateValue = to
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            if (textField == customDeadlineName) {
                CustomDeadline.name = textField.stringValue
            }
        }
    }
    
    @IBAction func launchAtLogin(_ sender: NSButton) {
        if LoginServiceKit.isExistLoginItems() {
            LoginServiceKit.removeLoginItems()
        } else {
            LoginServiceKit.addLoginItems()
        }
                
        sender.state = LoginServiceKit.isExistLoginItems() ? .on : .off
    }
    
    @IBAction func onCustomDeadlineTimeFromChange(_ sender: NSDatePicker) {
        CustomDeadline.from = sender.dateValue
    }
    
    @IBAction func onCustomDeadlineTimeToChange(_ sender: NSDatePicker) {
        CustomDeadline.to = sender.dateValue
    }
    
    @IBAction func onProgressBarVisibleChange(_ sender: NSButton) {
        AppDelegate.shared!.setProgressBarVisibility(bool: sender.state == NSControl.StateValue.on)
    }
    
    @objc func openTwitterProfile(_ sender: Any) {
        if let url = URL(string: "https://twitter.com/briannvalente"),
            NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @objc  func openGithub(_ sender: Any) {
        if let url = URL(string: "https://github.com/brianvalente"),
            NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @IBAction func onProgressBarColorChange(_ sender: NSButton) {
        AppDelegate.shared!.changeProgressBarColor(color: (sender.identifier?.rawValue)!)
    }
}

