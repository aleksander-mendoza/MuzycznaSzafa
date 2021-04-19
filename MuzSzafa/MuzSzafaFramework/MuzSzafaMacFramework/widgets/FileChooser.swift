//
//  FileChooser.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 15/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
open class FileChooser: NSView,NSTextFieldDelegate {

    open var localizedTitle:String{
        get{
            return filePanel.title
        }
        set{
            filePanel.title = getLocalizedString(for: "Choose file")
        }
    }
    open var title:String{
        get{
            return filePanel.title
        }
        set{
            filePanel.title = newValue
        }
    }
    open var message:String{
        get{
            return filePanel.message
        }
        set{
            filePanel.message = newValue
        }
    }
    open var localizedMessage:String{
        get{
            return filePanel.message
        }
        set{
            filePanel.message = getLocalizedString(for: newValue)
        }
    }
    open var prompt:String{
        get{
            return filePanel.prompt
        }
        set{
            filePanel.prompt = newValue
        }
    }
    open var localizedPrompt:String{
        get{
            return filePanel.prompt
        }
        set{
            filePanel.prompt = getLocalizedString(for: newValue)
        }
    }
    open var allowedFileTypes:[String]?{
        get{
            return filePanel.allowedFileTypes
        }
        set{
            filePanel.allowedFileTypes = newValue
        }
    }
    open var canChooseDirectories:Bool{
        get{
            return filePanel.canChooseDirectories
        }
        set{
            filePanel.canChooseDirectories = newValue
        }
    }
    open var canChooseFiles:Bool{
        get{
            return filePanel.canChooseFiles
        }
        set{
            filePanel.canChooseFiles = newValue
        }
    }
    open var showsCaution:Bool{
        get{
            return !caution.isHidden
        }
        set{
            caution.isHidden = !newValue
        }
    }
    private func checkUrlValid(_ url:URL?)->Bool{
        guard let url = url else{
            return false
        }
        return checkUrlValid(url.path)
    }
    private func checkUrlValid(_ path:String)->Bool{
        let out = FileManager.default.fileExists(atPath: path)
        return out
    }
    open var isUrlValid:Bool{
        get{
           return checkUrlValid(url)
        }
    }
    private func updateCaution(){
        if automaticallyShowCaution{
            if field.stringValue.isEmpty{
                showsCaution = false
            }else{
                let valid = isUrlValid
                showsCaution = !valid
            }
        }
    }
    open var automaticallyShowCaution:Bool=false
    open var onChangeImpl:((URL?)->Void)?
    open var filePanel = NSOpenPanel()
    open var url:URL?{
        set{
            if let p = newValue?.path{
                field.stringValue = p
                if automaticallyShowCaution{
                    let valid = checkUrlValid(p)
                    showsCaution = !valid
                }
            }else{
                field.stringValue = ""
                if automaticallyShowCaution{
                    showsCaution = false
                }
            }
        }
        get{
            return URL(string: field.stringValue)
        }
    }
    @IBAction func open(_ sender: Any) {
        let defURL = url
        filePanel.directoryURL = defURL
        filePanel.runModal()
        if let new = filePanel.url{
            url = new
            onChangeImpl?(new)
        }
        
    }
    open override func controlTextDidChange(_ obj: Notification) {
        onChangeImpl?(url)
        updateCaution()
    }
    @IBOutlet weak var field: NSTextField!{
        didSet{
            field.delegate = self
        }
    }
    @IBOutlet var view: NSView!
    
    @IBOutlet weak var caution: NSButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        let bundle = Bundle(for: type(of: self))
        let name = NSNib.Name(rawValue: "FileChooser")
        bundle.loadNibNamed(name, owner: self, topLevelObjects: nil)
        self.view.frame = self.bounds
        self.addSubview(view)
    }
    
    
}
