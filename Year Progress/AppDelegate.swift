//
//  AppDelegate.swift
//  Year Progress
//
//  Created by Brian Valente on 11/19/18.
//  Copyright © 2018 Brian Valente. All rights reserved.
//

import Cocoa
import Cartography
import ProgressKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    public static var shared: AppDelegate?

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var preferencesWindowController: NSWindowController?
    var progressBar: ProgressBar!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        preferencesWindowController = storyboard.instantiateController(withIdentifier: "Preferences") as? NSWindowController
        
        if let button = statusItem.button {
            progressBar = ProgressBar(frame: NSRect(x: 0, y: 0, width: button.frame.height * 1.5, height: button.frame.height * 0.5))
            
            progressBar.progress = CGFloat(getYearProgressPercentage()) / 100
            progressBar.background = NSColor.gray.withAlphaComponent(0.35)
            
            if let color = UserDefaults.standard.string(forKey: "progressbar_color") {
                print(color)
                progressBar.foreground = getColorByName(color: color)!
            } else {
                progressBar.foreground = NSColor.gray
            }
            
            progressBar.borderColor = NSColor.clear
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(progressBar)
            
            constrain(button, progressBar) { button, progressBar in
                progressBar.height == button.height * 0.5
                progressBar.width == button.height * 1.5
                progressBar.centerY == button.centerY
            }
            
            button.title = "        Year: \(getYearProgressPercentage())%"
            button.font = NSFont(name: "San Francisco", size: 1)
            button.action = #selector(onClick)
        }
    }
    
    @objc func onClick() {
        openWindow()
        //exit(0)
    }
    
    func openWindow() {
        if let window = preferencesWindowController?.window {
            if window.isVisible {
                if (!window.isKeyWindow) {
                    NSApp.activate(ignoringOtherApps: true)
                    window.makeKeyAndOrderFront(nil)
                } else {
                    exit(0)
                }
            } else {
                preferencesWindowController?.showWindow(self)
                NSApp.activate(ignoringOtherApps: true)
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func changeProgressBarColor(color: String) {
        if let colorObj = getColorByName(color: color) {
            progressBar.foreground = colorObj
            UserDefaults.standard.setValue(color, forKey: "progressbar_color")
        }
    }
    
    func getColorByName(color: String) -> NSColor? {
        switch (color) {
        case "red":
            return NSColor.red
        case "green":
            return NSColor.green
        case "blue":
            return NSColor.blue
        case "yellow":
            return NSColor.yellow
        case "orange":
            return NSColor.orange
        case "purple":
            return NSColor.purple
        case "white":
            return NSColor.white
        case "gray":
            return NSColor.gray
        case "black":
            return NSColor.black
        default:
        return nil
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func getYearProgressPercentage() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate = formatter.date(from: "\(year)-01-01 00:00:00")!.timeIntervalSince1970
        let endDate = formatter.date(from: "\(year + 1)-01-01 00:00:00")!.timeIntervalSince1970
        let currentDate = date.timeIntervalSince1970
        
        let percentage = ((currentDate - startDate) * 100) / (endDate - startDate)
        
        return Int(percentage)
    }
}

