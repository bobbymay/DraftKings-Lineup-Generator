import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    
    // How many times lineups are generated
    static let loops = 10_000
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Lineups.setLeague()
        DKEntries.read()
        Points.read()
        Lineups.start()
    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let entries = DKEntries.edit() else {
            print("ERROR: problem editing DKEntries file")
            return
        }
        
        // Create save panel
        let sp = NSSavePanel()
        sp.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        sp.message = "Save edited lineups"
        sp.nameFieldStringValue = "Lineups.csv"
        sp.allowsOtherFileTypes = false
        sp.isExtensionHidden = false
        
        guard let url = sp.url, sp.runModal().rawValue == NSApplication.ModalResponse.OK.rawValue else {
            return
        }
        
        do {
            try entries.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
        
    }
    
}

