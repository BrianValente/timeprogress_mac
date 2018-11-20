//
//  ViewController.swift
//  Year Progress
//
//  Created by Brian Valente on 11/19/18.
//  Copyright © 2018 Brian Valente. All rights reserved.
//

import Cocoa

class Preferences: NSViewController {
    
//    override func loadView() {
//        let view = NSView(frame: NSMakeRect(0,0,100,100))
//        view.wantsLayer = true
//        view.layer?.borderWidth = 2
//        view.layer?.borderColor = NSColor.red.cgColor
//        self.view = view
//    }
    
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

