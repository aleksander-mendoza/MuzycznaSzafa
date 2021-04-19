//
//  Dialogs.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
import MuzSzafaShared
public func dialogOKCancel(msg: String, text: String="") -> Bool {
	return dialogOKCancel(localMsg: getLocalizedString(for: msg),
						  localText: getLocalizedString(for: text))
}
public func dialogOKCancel(localMsg: String, localText: String="") -> Bool {

    let alert = NSAlert()
    alert.messageText = localMsg
    alert.informativeText = localText
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: getLocalizedString(for: "Cancel"))
	if !Thread.isMainThread{
		return DispatchQueue.main.sync() {
			return alert.runModal() == .alertFirstButtonReturn
		}
	}
    return alert.runModal() == .alertFirstButtonReturn
}

public func dialogOK(msg: String, text: String="") {
    let alert = NSAlert()
    alert.messageText = getLocalizedString(for: msg)
    alert.informativeText = getLocalizedString(for: text)
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
	if !Thread.isMainThread{
		_ = DispatchQueue.main.sync() {
			alert.runModal() == .alertFirstButtonReturn
		}
	}else{
    	alert.runModal()
	}
}

public func dialogException(msg: String, text: String="",_ f:()throws->Void) {
    
    do{
        try f()
    }catch let e{
        print("\(msg):\(text)\n - \(e)")
        dialogOK(msg: msg,text:"\(text)\n\(e.localizedDescription)\n\(e)")
    }
}


public func dialogSave(title: String, msg: String="",allowedFileTypes:[String]?=nil) -> URL? {
    let filePanel = NSSavePanel()
    filePanel.prompt = getLocalizedString(for: "Save")
    filePanel.worksWhenModal = true
    filePanel.title = getLocalizedString(for: title)
    filePanel.message = getLocalizedString(for: msg)
    filePanel.allowedFileTypes = allowedFileTypes
	if !Thread.isMainThread{
		_ = DispatchQueue.main.sync() {
			filePanel.runModal()
		}
	}else{
		filePanel.runModal()
	}
	
    return filePanel.url
}

public func dialogOpen(title: String,
                       msg: String="",
                       allowedFileTypes:[String]?=nil,
                       url:URL?=nil,
                       canChooseDirectories:Bool=false,
                       canChooseFiles:Bool=true) -> URL? {
    let filePanel = NSOpenPanel()
    if let u = url{
        filePanel.directoryURL = u
    }
    filePanel.prompt = getLocalizedString(for: "Open")
    filePanel.worksWhenModal = true
    filePanel.title = getLocalizedString(for: title)
    filePanel.message = getLocalizedString(for: msg)
    filePanel.allowedFileTypes = allowedFileTypes
    filePanel.canChooseDirectories = canChooseDirectories
    filePanel.canChooseFiles = canChooseFiles
	if !Thread.isMainThread{
		_ = DispatchQueue.main.sync() {
			filePanel.runModal()
		}
	}else{
		filePanel.runModal()
	}
    return filePanel.url
}

