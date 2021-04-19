////
////  InstrumentAccessoriesViewController.swift
////  MuzSzafaMac
////
////  Created by Alagris on 22/08/2018.
////  Copyright © 2018 alagris. All rights reserved.
////
//
//import Cocoa
//import MuzSzafaMacFramework
//import MuzSzafaShared
//
//class InstrumentAccessoriesViewController: NSViewController, NSTextFieldDelegate {
//    
//    var instrument:Instrument!
//    var showInstrumentCallback:((Instrument)->())?
//    override func controlTextDidChange(_ obj: Notification) {
//        showButton.isEnabled = false
//        removeButton.isEnabled = false
//        accessories.reloadData()
//    }
//    
//    @IBOutlet weak var nameField: NSTextField!{
//        didSet{
//            nameField.delegate = self
//        }
//    }
//    
//    @IBOutlet weak var accessories: EntitiesFilteredTableView!
//    
//    @IBAction func done(_ sender: Any) {
//        dismiss(self)
//    }
//    @IBOutlet weak var showButton: NSButton!
//    @IBAction func show(_ sender: Any) {
//        if let mo = Instrument.cast(accessories.selectedObj){
//            dismiss(nil)
//            showInstrumentCallback?(mo)
//        }
//    }
//    @IBOutlet weak var removeButton: NSButton!
//    @IBAction func remove(_ sender: Any) {
//        if let mo = Instrument.cast(accessories.selectedObj){
//            mo.parent_accessory = nil
//            CoreContext.shared.save()
//            accessories.reloadData()
//        }
//        
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let ent = CoreContext.shared.cache.find("Instrument")!
//        accessories.selectionCallback = {
//            [unowned self] in
//            let enable = self.accessories.selectedObj != nil
//            self.showButton.isEnabled = enable
//            self.removeButton.isEnabled = enable
//        }
//        showButton.isEnabled = false
//        removeButton.isEnabled = false
//        accessories.ent = ent
//        let r = ent.repr
//        accessories.filter = {
//            [unowned self] mo in
//            r.loadPrimary(mo: mo)
//            return self.nameField.stringValue.fuzzyCompare(r.combinePrimary())
//        }
//        accessories.reloadData(pred: NSPredicate("parent_accessory", instrument))
//    }
//    
//    
//    
//}
