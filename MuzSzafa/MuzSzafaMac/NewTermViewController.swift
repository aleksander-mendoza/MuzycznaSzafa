//
//  NewTermViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 01/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
import MuzSzafaMacFramework
class NewTermViewController: NSViewController {

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53{
            goBack(nil)
        }
    }
	public var parentResource:Reloadable?
	private var mostRecentlySelectedDeal:Deal?
    @IBAction func goBack(_ sender: Any?) {
        if properties.ent == nil{
			parentResource?.reloadData()
            dismiss(nil)
        }else if properties.ent?.name == "Client"
			|| properties.ent?.name == "Instrument"{
			properties.reloadData(ent: CoreContext.find(ent: "Deal"), obj: mostRecentlySelectedDeal)
		}else{
            setControls()
        }
    }
    
    @IBOutlet weak var terms: EntitiesTableView!{
        didSet{
            terms.selectionCallback = {
                [weak self] in self!.terms.tickable = false
            }
        }
    }
    
    @IBOutlet weak var properties: CoreDataTable!
    private var pair:TablePair!
    private func updateFilter(any:Any,_ event:PropertyTableEntryEvent){
        return updateFilter(any as! Date,event)
    }
    private func updateFilter(_ date:Date,_ event:PropertyTableEntryEvent){
        guard event is PropertyTableEntryValChangeEvent else {return}
        terms.pred = Deal.safePred(Deal.filterValidButWithoutPayment(for: date))
    }
    private func extendSelectedDeals(_ sender: Any?,_ event:PropertyTableEntryEvent){
        guard event is PropertyTableEntryValChangeEvent else {return}
        for deal in terms.ticked(){
            _ = Payment.createNew(Deal.cast(deal)!)
        }
        terms.reloadData()
        CoreContext.shared.save()
    }
    private func terminateSelectedDeals(_ sender: Any?, event: PropertyTableEntryEvent){
        guard event is PropertyTableEntryValChangeEvent else {return}
        for deal in terms.ticked(){
            let d = Deal.cast(deal)!
            d.status = Deal.Status.Terminated.rawValue
			if let instruments = d.instrument{
				for entry in instruments{
					let inst = Instrument.cast(entry)!
					inst.available = true
				}
			}
        }
        terms.reloadData()
        CoreContext.shared.save()
    }
    private let cancel = ManualPropertyEntry(localizedName: "Cancel", type: .button)
    private let terminateDeals = ManualPropertyEntry(localizedName: "Terminate deals",type: .button)
    private let extendDeals = ManualPropertyEntry(localizedName: "Extend deals",
                                                  type: .button)
    private let date = ManualPropertyEntry(localizedName: "date",
                                           type: .date,
                                           val: Date())
    private func setControls(){
        properties.setLocalizedTitle(title: "Settings")
        properties.reloadData(entries: [date,cancel,terminateDeals,extendDeals])
    }
    override func viewDidLoad() {
		date.onChangeImpl = {
			[weak self] (any:Any?, event:PropertyTableEntryEvent) in
			guard let date = any as! Date? else{return}
			self!.updateFilter(date, event)
			self!.terms.reloadData()
		}
        cancel.onChangeImpl = { [weak self] _,_ in
            self!.goBack(nil)
        }
        terminateDeals.onChangeImpl = terminateSelectedDeals
        extendDeals.onChangeImpl = extendSelectedDeals
        updateFilter(Date(),PropertyTableEntryValChangeEvent.singleton)
        terms.tickable = true
        pair = TablePair(prop: properties,
                         list: terms,
						 ent: "Deal",
                         cntx: CoreContext.shared
                         )!
		pair.onChangeImpl = {
			[weak self] val,attr,event in
			if self!.properties.ent?.name == "Deal"{
				if event is PropertyTableEntryRelatPressEvent{
					if attr.name == "client" ||  attr.name == "instrument"{
						let v = val as! CellRelatEntry
						self!.mostRecentlySelectedDeal = Deal.cast(self!.properties.obj)
						self!.properties.reloadData(ent: v.attr.destEnt, obj: v.mo)
					}
				}
			}
		}
        setControls()
		
    }
    
}
