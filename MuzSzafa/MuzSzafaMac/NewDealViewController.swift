////
////  NewInstrumentViewController.swift
////  MuzSzafaMac
////
////  Created by Alagris on 08/04/2018.
////  Copyright © 2018 alagris. All rights reserved.
////
//
//import Cocoa
//import MuzSzafaShared
//import MuzSzafaMacFramework
//
//class NewDealViewController: NSViewController, NSTextFieldDelegate, PopoverController {
//    var parentResource: Reloadable?
//    var client:Client!
//    var instrument:NSSet!
//    func fail() {
//
//    }
//
//    @IBOutlet weak var properties: PropertyTable!
//
//    @IBOutlet weak var done: NSButton!
//
//    private var validId:Bool=false
//    private func updateDone(){
//		done.isEnabled = validId && {
//			for i in instrument{
//				if !Instrument.cast(i)!.available{
//					return false
//				}
//			}
//			return true
//		}()
//    }
//    @IBAction func cancel(_ sender: Any) {
//        dismiss(self)
//    }
//    private func idChanged(_ val:Any?,_ event:PropertyTableEntryEvent){
//        guard event is PropertyTableEntryValChangeEvent else {return}
//        if let str = val as! String? {
//            let ent = CoreContext.find(ent:"Deal")!
//            self.validId = validateName(str) && !ent.exists(str)
//            self.updateDone()
//        }
//    }
//    private var idEntry:ManualPropertyEntry!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        idEntry = ManualPropertyEntry(localizedName: "id",
//                                      type: .string,
//                                      val: "",
//                                      callback: idChanged)
//        let ent = CoreContext.find(ent: "Deal")!
//        let iAttr = ent.find(attr: "instrument") as! CoreDataRelatEntry
//		let iVal = CellRelatToManyEntry(mos:instrument,attr:iAttr)
//		let cAttr = ent.find(attr: "client")! as! CoreDataRelatEntry
//		let cVal = CellRelatEntry(mo:client,attr:cAttr)
//        let pred = Deal.filterValid(for: Date())
//		let conflicts = { () -> Bool in
//			for i in self.instrument{
//				let inst = Instrument.cast(i)!
//				if !(inst.deal?.filtered(using:pred).isEmpty ?? true){
//					return true
//				}
//			}
//			return false
//		}()
//        properties.entries = [
//            idEntry,
//            ManualPropertyEntry(localizedName: "client", type: .relat, val: cVal),
//            ManualPropertyEntry(localizedName: "instrument", type: .relatToMany, val: iVal),
//            ManualPropertyEntry(localizedName: "available", type: .display, val: true),
//            ManualPropertyEntry(localizedName: "in_conflict", type: .display, val: conflicts)
//        ]
//
//        updateDone()
//    }
//
//
//    @IBAction func done(_ sender: NSButton) {
//        let id = idEntry.value as! String?
//        createNewDeal(inst: instrument, client: client, id: id!)
//    }
//
//
//}
