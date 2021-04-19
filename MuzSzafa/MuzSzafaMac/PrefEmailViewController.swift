//
//  PrefEmailViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 15/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaMacFramework
class PrefEmailViewController: NSViewController {

    static let emailPatternLocationKey = "emailPatternLocation"
    @IBOutlet weak var emailPatternLocation: FileChooser!{
        didSet{
            
            emailPatternLocation.onChangeImpl = {
                UserDefaults.standard.set($0, forKey: PrefEmailViewController.emailPatternLocationKey)
            }
            emailPatternLocation.allowedFileTypes = NSAttributedString.DocumentType.supportedExtensions
            let url = UserDefaults.standard.url(forKey: PrefEmailViewController.emailPatternLocationKey)
            emailPatternLocation.automaticallyShowCaution = true
            emailPatternLocation.url = url
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
