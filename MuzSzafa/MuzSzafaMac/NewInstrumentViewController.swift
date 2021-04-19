//
//  NewInstrumentViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 08/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
import MuzSzafaMacFramework

class NewInstrumentViewController: NSViewController, NSTextFieldDelegate, PopoverController {
    var parentResource: Reloadable?
    
    func fail() {
        
    }
    
    
    @IBOutlet weak var idField: NSTextField!{
        didSet{
            idField.delegate = self
        }
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if let src = obj.object as? NSTextField{
            if src == idField{
                idChange(idField)
            }else if src == typeField{
                typeChange(typeField)
            }
        }
    }
    func idChange(_ sender: NSTextField) {
        let str = sender.stringValue
        let ent = CoreContext.shared.cache.find("InstrumentType")!
        validId = validateName(str) && !ent.exists(str)
        updateDone()
    }
    @IBOutlet weak var typeField: NSTextField!{
        didSet{
            typeField.delegate = self
        }
    }
    
    func typeChange(_ sender: NSTextField) {
        validType = validateName(sender.stringValue)
        updateDone()
    }
    @IBOutlet weak var types: EntitiesTableView!
    
    @IBOutlet weak var done: NSButton!
    
    private var validId:Bool=false
    private var validType:Bool=false
    private func updateDone(){
        done.isEnabled = validId && validType
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ent = CoreContext.shared.cache.find("InstrumentType")!
        types.reloadData(ent: ent)
        
        types.selectionCallback = {
            [weak self] in
            if let obj = InstrumentType.cast(self!.types.selectedObj){
                self!.typeField.stringValue = obj.type ?? ""
                self!.typeChange(self!.typeField)
            }
        }
        updateDone()
        
    }
    
    @IBAction func done(_ sender: NSButton) {
        createNewInstrument(type: typeField.stringValue, id: idField.stringValue)
    }
    
    
}
