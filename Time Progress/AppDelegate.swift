//
//  AppDelegate.swift
//  Time Progress
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
    var statusBarButton: NSStatusBarButton!
    var preferencesWindowController: NSWindowController?
    var progressBar: ProgressBar?
    
    var dayMenuItem: NSMenuItem!
    var weekMenuItem: NSMenuItem!
    var monthMenuItem: NSMenuItem!
    var yearMenuItem: NSMenuItem!
    var customMenuItem: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        preferencesWindowController = storyboard.instantiateController(withIdentifier: "Preferences") as? NSWindowController
        
        renderMenuBar()
    }
    
    func renderMenuBar() {
        if let button = statusItem.button {
            statusBarButton = button
            
            statusBarButton.font = NSFont(name: "San Francisco", size: 1)
            
            updatePercentage(nil)
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePercentage), userInfo: nil, repeats: true)
            
            addMenu()
            loadProgressBarVisibility()
        }
    }
    
    @objc func updatePercentage(_ sender: Any?) {
        let value = getCurrentModeValue()
        let stringValue = getCurrentModeStringValue()
        let before = getProgressBarVisibility() ? "          " : ""
        statusBarButton.title = "\(before)\(getCurrentModeName()): \(stringValue)"
        progressBar?.progress = CGFloat(value) / 100
    }
    
    func getCurrentModeName() -> String {
        switch getCurrentMode() {
        case "day":
            return "Day"
        case "week":
            return "Week"
        case "month":
            return "Month"
        case "year":
            return "Year"
        case "custom":
            return Deadline.name
        default:
            return ""
        }
    }
    
    func getCurrentModeStringValue() -> String {
//        switch getCurrentMode() {
//        case "day":
//            return String(getDayProgressPercentage()) + "%"
//        case "week":
//            return String(getWeekProgressPercentage()) + "%"
//        case "month":
//            return String(getMonthProgressPercentage()) + "%"
//        case "year":
//            return String(getYearProgressPercentage()) + "%"
//        case "custom":
//            return Deadline.stringValue
//        default:
//            return "-1%"
//        }
        
        return String(getCurrentModeValue()) + "%"
    }
    
    func getCurrentModeValue() -> Int {
        var value = 69
        switch getCurrentMode() {
        case "day":
            value = getDayProgressPercentage()
        case "week":
            value = getWeekProgressPercentage()
        case "month":
            value = getMonthProgressPercentage()
        case "year":
            value = getYearProgressPercentage()
        case "custom",
             "deadline":
            value = Deadline.percentage
        default:
            value = 69
        }
        
        let invert = UserDefaults.standard.bool(forKey: "settings.inversepercentage");
        
        if (invert) {
            value = 100 - value
        }
        
        return value
    }
    
    func getCurrentMode() -> String {
        if let mode = UserDefaults.standard.string(forKey: "mode") {
            return mode
        } else {
            return "year"
        }
    }
    
    @objc func openPreferences(_ sender: Any?) {
        if let window = preferencesWindowController?.window {
            if window.isVisible {
                NSApp.activate(ignoringOtherApps: true)
                window.makeKeyAndOrderFront(nil)
            } else {
                preferencesWindowController?.showWindow(self)
                NSApp.activate(ignoringOtherApps: true)
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    @objc func setMode(_ sender: NSMenuItem) {
        UserDefaults.standard.setValue(sender.identifier?.rawValue, forKey: "mode")
        
        dayMenuItem.state = .off
        weekMenuItem.state = .off
        monthMenuItem.state = .off
        yearMenuItem.state = .off
        customMenuItem.state = .off
        
        sender.state = .on
    }
    
    func getProgressBarVisibility() -> Bool {
        //return (UserDefaults.standard.object(forKey: "progressbar.visible") as? Bool) ?? true
        return progressBar != nil
    }
    
    func setProgressBarVisibility(bool: Bool) {
        UserDefaults.standard.setValue(bool, forKey: "progressbar.visible")
        loadProgressBarVisibility()
    }
    
    func loadProgressBarVisibility() {
        if UserDefaults.standard.bool(forKey: "progressbar.visible") && progressBar == nil {
            progressBar = ProgressBar(frame: NSRect(x: 0, y: 0, width: statusBarButton.frame.height * 1.5, height: statusBarButton.frame.height * 0.6))
            
            progressBar!.progress = CGFloat(getYearProgressPercentage()) / 100
            progressBar!.background = NSColor.gray.withAlphaComponent(0.35)
            progressBar!.foreground = getColorByName(color: getProgressBarColorName())!
            
            progressBar!.borderColor = NSColor.clear
            progressBar!.translatesAutoresizingMaskIntoConstraints = false
            
            statusBarButton.addSubview(progressBar!)
            
            constrain(statusBarButton, progressBar!) { button, progressBar in
                progressBar.height == button.height * 0.6
                progressBar.width == button.height * 1.5
                progressBar.centerY == button.centerY
                progressBar.left == button.left + 5
            }
        } else {
            progressBar?.removeFromSuperview()
            progressBar = nil
        }
        updatePercentage(nil)
    }
    
    func addMenu() {
        let menu = NSMenu()
        
        dayMenuItem = NSMenuItem(title: "Day", action: #selector(setMode), keyEquivalent: "");
        weekMenuItem = NSMenuItem(title: "Week", action: #selector(setMode), keyEquivalent: "");
        monthMenuItem = NSMenuItem(title: "Month", action: #selector(setMode), keyEquivalent: "");
        yearMenuItem = NSMenuItem(title: "Year", action: #selector(setMode), keyEquivalent: "");
        customMenuItem = NSMenuItem(title: Deadline.name, action: #selector(setMode), keyEquivalent: "");
        
        dayMenuItem.identifier = NSUserInterfaceItemIdentifier("day")
        weekMenuItem.identifier = NSUserInterfaceItemIdentifier("week")
        monthMenuItem.identifier = NSUserInterfaceItemIdentifier("month")
        yearMenuItem.identifier = NSUserInterfaceItemIdentifier("year")
        customMenuItem.identifier = NSUserInterfaceItemIdentifier("custom")
        
        switch getCurrentMode() {
        case "day":
            dayMenuItem.state = .on
        case "week":
            weekMenuItem.state = .on
        case "month":
            monthMenuItem.state = .on
        case "year":
            yearMenuItem.state = .on
        case "custom":
            customMenuItem.state = .on
        default:
            break
        }
        
        menu.addItem(dayMenuItem)
        menu.addItem(weekMenuItem)
        menu.addItem(monthMenuItem)
        menu.addItem(yearMenuItem)
        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(openPreferences), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        statusItem.menu = menu
    }
    
    func changeProgressBarColor(color: String) {
        if let colorObj = getColorByName(color: color) {
            progressBar?.foreground = colorObj
            UserDefaults.standard.setValue(color, forKey: "progressbar.color")
        }
    }
    
    func getProgressBarColorName() -> String {
        if let color = UserDefaults.standard.string(forKey: "progressbar.color") {
            return color
        } else {
            return "gray"
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
    
    func getMonthProgressPercentage() -> Int {
        let date = Date()
        
        let start = date.startOfMonth().midnight.timeIntervalSince1970
        let end = date.endOfMonth().dayAfter.midnight.timeIntervalSince1970
        let now = date.timeIntervalSince1970
        
        let monthSeconds = end - start
        let calcNow = now - start
        
        let percentage = (calcNow * 100) / monthSeconds
        
        return Int(percentage)
    }
    
    func getWeekProgressPercentage() -> Int {
        let date = Date()
        var thisWeek = date.previous(.monday).midnight.timeIntervalSince1970
        
        // if today's monday
        if (Calendar(identifier: .gregorian).dateComponents([.weekday], from: date).weekday == 2) {
            thisWeek = date.midnight.timeIntervalSince1970
        }
        
        let nextWeek = date.next(.monday).midnight.timeIntervalSince1970
        let now = date.timeIntervalSince1970
        
        let weekSeconds = nextWeek - thisWeek
        let calcNow = now - thisWeek
        
        let percentage = (calcNow * 100) / weekSeconds
        
        return Int(percentage)
    }
    
    func getDayProgressPercentage() -> Int {
        let today = Date().midnight.timeIntervalSince1970
        let tomorrow = Date.tomorrow.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        let daySeconds = tomorrow - today
        let calcNow = now - today
        
        let percentage = (calcNow * 100) / daySeconds
        
        return Int(percentage)
    }
}

