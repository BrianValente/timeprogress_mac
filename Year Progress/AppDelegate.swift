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

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            let progressBar: ProgressBar = ProgressBar(frame: NSRect(x: 0, y: 0, width: button.frame.height * 1.5, height: button.frame.height * 0.5))
            
            progressBar.progress = CGFloat(getYearProgressPercentage()) / 100
            progressBar.background = NSColor.gray.withAlphaComponent(0.5)
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
            button.action = #selector(close)
        }
    }
    
    @objc func close() {
        exit(0)
    }
    
    func openWindow() {
        let newWindow = NSWindow(contentRect: NSMakeRect(10, 10, 300, 300), styleMask: .resizable, backing: .buffered, defer: false)

        let controller = ViewController()
        let content = newWindow.contentView! as NSView
        let view = controller.view
        content.addSubview(view)

        newWindow.makeKeyAndOrderFront(nil)
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

