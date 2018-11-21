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
    var progressBar: ProgressBar!
    
    var dayMenuItem: NSMenuItem!
    var weekMenuItem: NSMenuItem!
    var monthMenuItem: NSMenuItem!
    var yearMenuItem: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        preferencesWindowController = storyboard.instantiateController(withIdentifier: "Preferences") as? NSWindowController
        
        if let button = statusItem.button {
            statusBarButton = button
            
            progressBar = ProgressBar(frame: NSRect(x: 0, y: 0, width: button.frame.height * 1.5, height: button.frame.height * 0.5))
            
            progressBar.progress = CGFloat(getYearProgressPercentage()) / 100
            progressBar.background = NSColor.gray.withAlphaComponent(0.35)
            progressBar.foreground = getColorByName(color: getProgressBarColorName())!
            
            progressBar.borderColor = NSColor.clear
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(progressBar)
            
            constrain(button, progressBar) { button, progressBar in
                progressBar.height == button.height * 0.5
                progressBar.width == button.height * 1.5
                progressBar.centerY == button.centerY
            }
            
            //button.title = "        Year: \(getYearProgressPercentage())%"
            button.font = NSFont(name: "San Francisco", size: 1)
            //button.action = #selector(onClick)
            
            updatePercentage(nil)
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePercentage), userInfo: nil, repeats: true)
            
            addMenu()
        }
    }
    
    @objc func updatePercentage(_ sender: Any?) {
        let value = getCurrentModeValue()
        statusBarButton.title = "         \(getCurrentModeName()): \(value)%"
        progressBar.progress = CGFloat(value) / 100
    }
    
    @objc func onClick() {
        openWindow()
        //exit(0)
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
        default:
            return ""
        }
    }
    
    func getCurrentModeValue() -> Int {
        switch getCurrentMode() {
        case "day":
            return getDayProgressPercentage()
        case "week":
            return getWeekProgressPercentage()
        case "month":
            return getMonthProgressPercentage()
        case "year":
            return getYearProgressPercentage()
        default:
            return 4
        }
    }
    
    func getCurrentMode() -> String {
        if let mode = UserDefaults.standard.string(forKey: "mode") {
            return mode
        } else {
            return "year"
        }
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
    
    @objc func openPreferences(_ sender: Any?) {
        if let window = preferencesWindowController?.window {
            if window.isVisible {
                //if (!window.isKeyWindow) {
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
        
        sender.state = .on
    }
    
    func addMenu() {
        let menu = NSMenu()
        
        dayMenuItem = NSMenuItem(title: "Day", action: #selector(setMode), keyEquivalent: "");
        weekMenuItem = NSMenuItem(title: "Week", action: #selector(setMode), keyEquivalent: "");
        monthMenuItem = NSMenuItem(title: "Month", action: #selector(setMode), keyEquivalent: "");
        yearMenuItem = NSMenuItem(title: "Year", action: #selector(setMode), keyEquivalent: "");
        
        dayMenuItem.identifier = NSUserInterfaceItemIdentifier("day")
        weekMenuItem.identifier = NSUserInterfaceItemIdentifier("week")
        monthMenuItem.identifier = NSUserInterfaceItemIdentifier("month")
        yearMenuItem.identifier = NSUserInterfaceItemIdentifier("year")
        
        switch getCurrentMode() {
        case "day":
            dayMenuItem.state = .on
        case "week":
            weekMenuItem.state = .on
        case "month":
            monthMenuItem.state = .on
        case "year":
            yearMenuItem.state = .on
        default:
            break
        }
        
        menu.addItem(dayMenuItem)
        menu.addItem(weekMenuItem)
        menu.addItem(monthMenuItem)
        menu.addItem(yearMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(openPreferences), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        statusItem.menu = menu
    }
    
    func changeProgressBarColor(color: String) {
        if let colorObj = getColorByName(color: color) {
            progressBar.foreground = colorObj
            UserDefaults.standard.setValue(color, forKey: "progressbar_color")
        }
    }
    
    func getProgressBarColorName() -> String {
        if let color = UserDefaults.standard.string(forKey: "progressbar_color") {
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
        let start = date.startOfMonth().timeIntervalSince1970
        let end = date.endOfMonth().timeIntervalSince1970
        let now = date.timeIntervalSince1970
        print(start, end, now)

        
        let percentage = ((end - now) * 100) / (end - start)
        
        return Int(percentage)
    }
    
    func getWeekProgressPercentage() -> Int {
        let date = Date()
        let monday = date.previous(.monday).timeIntervalSince1970
        let sunday = date.next(.sunday).timeIntervalSince1970
        let now = date.timeIntervalSince1970
        
        let percentage = ((now - monday) * 100) / (sunday - now)
        
        return Int(percentage)
    }
    
    func getDayProgressPercentage() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: date)
        let month = calendar.component(Calendar.Component.month, from: date)
        let day = calendar.component(Calendar.Component.day, from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let today = formatter.date(from: "\(year)-\(month)-\(day) 00:00:00")!.timeIntervalSince1970
        let tomorrow = today + 86400
        let now = date.timeIntervalSince1970
        
        let percentage = ((now - today) * 100) / (tomorrow - today)
        
        return Int(percentage)
    }
}

