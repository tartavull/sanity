import Cocoa

let mainAppBundleIdentifier = "com.tartavull.sanity.sanity"

func launchMainApp() {
    // Check if the main app is already running.
    let isRunning = NSWorkspace.shared.runningApplications.contains {
        $0.bundleIdentifier == mainAppBundleIdentifier
    }
    
    if !isRunning {
        // Determine the main app URL.
        // Assuming your helper is embedded in your main app at:
        //   MainApp.app/Contents/Library/LoginItems/YourHelper.app
        // then the main app is two levels up from the helper's bundle URL.
        let helperBundleURL = Bundle.main.bundleURL
        let mainAppURL = helperBundleURL.deletingLastPathComponent().deletingLastPathComponent()
        
        // Launch the main app.
        NSWorkspace.shared.openApplication(at: mainAppURL,
                                           configuration: NSWorkspace.OpenConfiguration(),
                                           completionHandler: nil)
    }
}

// Launch the main app and then exit.
launchMainApp()
exit(0)
