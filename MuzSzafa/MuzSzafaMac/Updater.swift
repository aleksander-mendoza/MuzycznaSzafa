//
//  Updater.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 15/08/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
import MuzSzafaShared
import Cocoa

public enum UpdateError:Error{
    case couldNotGetBundleID
}
public func update(withRemote:RemoteConfig) throws{
    let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
    let tmpZipFile = tmpDir.appendingPathComponent("MuzSzafa.zip")
    let tmpUnzippedApp = tmpDir.appendingPathComponent("MuzSzafaMac.app")
    let tmpSwapScript = tmpDir.appendingPathComponent("MuzSzafaSwapScrip.sh")
    let bundle = Bundle.main
    let appURL = bundle.bundleURL
    print(appURL)
    guard let bundleID = bundle.bundleIdentifier else{
        throw UpdateError.couldNotGetBundleID
    }
    let apps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
    let pids = apps.converted(){String($0.processIdentifier)}
    print(pids.collect())
    let script = """
#!/bin/bash
for PID in \(pids.joined(separator: " "))
do
    kill -9 $PID
    while kill -0 $PID 2> /dev/null; do sleep .5; done;
done
TMP_DIR="\(tmpDir.path)"
ZIP="\(tmpZipFile.path)"
UNZIPPED="\(tmpUnzippedApp.path)"
APP="\(appURL.path)"
cd $TMP_DIR
unzip -o "$ZIP" || (osascript -e 'tell app "System Events" to display dialog "\(getLocalizedString(for: "failed_unzipping"))" ; exit)
rm -rf "$APP" || (osascript -e 'tell app "System Events" to display dialog "\(getLocalizedString(for: "failed_removing_old_version"))" ; exit)
mv "$UNZIPPED" "$APP" || (osascript -e 'tell app "System Events" to display dialog "\(getLocalizedString(for: "failed_installing_new_version"))" ; exit)
open "$APP" || (osascript -e 'tell app "System Events" to display dialog "\(getLocalizedString(for: "failed_opening_new_version"))" ; exit)
"""
    try script.write(to: tmpSwapScript, atomically: false, encoding: .ascii)
    try tmpSwapScript.setExecutable(owner:true,group: true,others: true)
    tmpZipFile.delete();
    tmpUnzippedApp.delete();
    print(tmpZipFile)
    Downloader.load(url: withRemote.osxURL!, to: tmpZipFile){
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [tmpSwapScript.absoluteURL.path]
        task.launch()
    }
    
    
    
}
