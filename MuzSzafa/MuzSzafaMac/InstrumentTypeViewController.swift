////
////  InstrumentTypePopover.swift
////  MuzSzafaMac
////
////  Created by Alagris on 26/04/2018.
////  Copyright © 2018 alagris. All rights reserved.
////
//
//import Cocoa
//import MuzSzafaShared
//import MuzSzafaMacFramework
//class InstrumentTypeViewController: NSViewController,PopoverController,NSTextFieldDelegate {
//    var parentResource: Reloadable?
//    
//    var instrument:Instrument!
//    
//    func fail() {
//    }
//    
//    
//    override func controlTextDidChange(_ obj: Notification) {
//        typeChange(typeField)
//    }
//    @IBOutlet weak var typeField: NSTextField!{
//        didSet{
//            typeField.delegate = self
//        }
//    }
//    
//    func typeChange(_ sender: NSTextField) {
//        done.isEnabled = validateName(sender.stringValue)
//    }
//    @IBOutlet weak var types: EntitiesTableView!
//    
//    @IBOutlet weak var done: NSButton!
//    
//    @IBAction func cancel(_ sender: Any) {
//        dismiss(self)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let ent = CoreContext.shared.cache.find("InstrumentType")!
//        types.ent = ent
//        
//        types.selectionCallback = {
//            [unowned self] in
//            if let obj = InstrumentType.cast(self.types.selectedObj){
//                self.typeField.stringValue = obj.type ?? ""
//                self.typeChange(self.typeField)
//            }
//        }
//        done.isEnabled = false
//        types.selectedObj = instrument.type
//        typeField.stringValue = instrument.type?.type ?? ""
//    }
//    
//    
//    @IBAction func done(_ sender: NSButton) {
//        let ent = CoreContext.shared.cache.find("InstrumentType")!
//        if let mo = ent.ensureExists(mainAttrVal: typeField.stringValue){
//            let type = InstrumentType.cast(mo)!
//            instrument.type = type
//            success()
//        }else{
//            fail()
//        }
//        
//    }
//    
//    
//}
