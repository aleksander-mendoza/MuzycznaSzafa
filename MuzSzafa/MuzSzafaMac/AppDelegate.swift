//
//  AppDelegate.swift
//  MuzSzafaMac
//
//  Created by Alagris on 22/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
import MuzSzafaMacFramework
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var hideTypesMenuItem: NSMenuItem!
    
    @IBOutlet weak var showTypesMenuItem: NSMenuItem!
    
    @IBOutlet weak var hidePaymentsMenuItem: NSMenuItem!
    
    @IBOutlet weak var showPaymentsMenuItem: NSMenuItem!
    var isShownTypesMenuItem:Bool{
        get{
            return showTypesMenuItem.isHidden
        }
        set{
            showTypesMenuItem.isHidden = !newValue
            hideTypesMenuItem.isHidden = newValue
        }
    }
    var isShownPaymentsMenuItem:Bool{
        get{
            return showPaymentsMenuItem.isHidden
        }
        set{
            showPaymentsMenuItem.isHidden = !newValue
            hidePaymentsMenuItem.isHidden = newValue
        }
    }
	
	
	
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		CoreContext.shared.observer.cacheLastEnabled = true
		DispatchQueue.global(qos: .background).async {
			if let cnf = RemoteConfig(){
				if cnf.compareTo(version: Bundle.main.versionString!) == 1{
					if dialogOKCancel(msg: "update_title", text: "update_text"){
						dialogException(msg: "update_fail"){
							try update(withRemote: cnf)
						}
					}
				}
			}
		}
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        CoreContext.shared.save()
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        return CoreContext.shared.get().undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        CoreContext.shared.save()
        return .terminateNow
    }
    func applicationDidBecomeActive(_ notification: Notification) {
        NSApp.unhide(nil)
    }
}

