import Cocoa
import ServiceManagement

func registerLoginItem() {
    if #available(macOS 13.0, *) {
        do {
            // Use the helper's bundle identifier here.
            try SMAppService.loginItem(identifier: "com.tartavull.sanity.helper").register()
            print("Helper registered successfully.")
        } catch {
            print("Failed to register helper: \(error)")
        }
    } else {
        print("SMAppService registration requires macOS 13.0 or later.")
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    let menu = NSMenu()
    var timer: Timer?
    
    
    // Reference to the toggle switch in the custom view.
    var loginToggleSwitch: NSSwitch!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        registerLoginItem()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            // Listen for both left and right mouse clicks.
            button.sendAction(on: [.rightMouseUp])
            button.action = #selector(statusItemClicked(_:))
            button.target = self
        }
        
        // Add the Quit menu item.
        let quitMenuItem = NSMenuItem(title: "Quit Sanity", action: #selector(quitApp), keyEquivalent: "")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        // Do the initial status update.
        updateStatus()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateStatus), userInfo: nil, repeats: true)
    }
    
    @objc func updateStatus() {
        let now = Date()
        let calendar = Calendar.current
        
        // Calculate day of the year.
        guard let dayOfYear = calendar.ordinality(of: .day, in: .year, for: now) else { return }
        let ordinalDay = "\(dayOfYear)" + ordinalSuffix(for: dayOfYear)
        
        // Calculate time-of-day percentage.
        let startOfDay = calendar.startOfDay(for: now)
        let secondsSinceStart = now.timeIntervalSince(startOfDay)
        let percentage = (secondsSinceStart / 86400) * 100
        let formattedPercentage = String(format: "%.1f%%", percentage)
        
        // Update status bar title.
        let title = "\(ordinalDay)  \(formattedPercentage)"
        statusItem.button?.title = title
        
        // Ensure the menu follows the current appearance.
        if let bestMatch = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) {
            menu.appearance = NSAppearance(named: bestMatch == .darkAqua ? .darkAqua : .aqua)
        }
    }
    
    func ordinalSuffix(for number: Int) -> String {
        let tens = number % 100
        if tens >= 11 && tens <= 13 {
            return "th"
        }
        switch number % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
    
    @objc func statusItemClicked(_ sender: NSStatusBarButton) {
        guard NSApp.currentEvent != nil else { return }
        if let button = statusItem.button {
            let menuOrigin = NSPoint(x: 0, y: button.bounds.height)
            menu.popUp(positioning: nil, at: menuOrigin, in: button)
        }
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
