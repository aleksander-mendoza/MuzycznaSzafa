//
//  ViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 22/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
import MuzSzafaMacFramework



class MainViewController: NSViewController, Reloadable {
    
    
    
    @IBOutlet weak var paymentsContainer: NSScrollView!
    @IBOutlet weak var instrumentTypesContainer: NSScrollView!
    
    private var tableGroup:TablePair!
    private let filter = EntFilterGroup(cntx: CoreContext.shared)
    private let sort = EntSortGroup(cntx: CoreContext.shared)
    
    @IBAction func purgeData(_ sender: NSMenuItem?){
        if dialogOKCancel(msg: "purge_warning"){
            CoreContext.shared.purge()
            reloadData()
        }
    }
    
    @IBAction func forceLoadDataFromDisk(_ sender: NSMenuItem?){
        CoreContext.shared.get().reset()
        reloadData()
    }
    @IBAction func forceWriteDataToDisk(_ sender: NSMenuItem?){
        CoreContext.shared.save()
    }
    
    
    @IBOutlet var TMP_DELETE_ME: NSTextView!
    @IBAction func sendDealWarningEmail(_ sender: NSMenuItem?){
        if let deal =  Deal.cast(deals.selectedObj){
            DealTemplateProcessor(deal:deal).sendEmail()
        }
        
    }
    @IBAction func generatePDF(_ sender: NSMenuItem?){
//        if let deal = deals.selectedObj as! Deal?{
//            let fTypes = NSAttributedString.DocumentType.supportedExtensions
//            guard let dest = dialogSave(title: "Export PDF", msg: "Choose destination", allowedFileTypes: ["pdf"]) else{
//                return
//            }
//            let proc = DealTemplateProcessor(deal:deal)
//
//            do{
//                let content = try proc.generateAttrString()
//                content.makePDF(to: dest)
//            }catch let e{
//                dialogOK(msg: e.localizedDescription)
//            }
//        }
        
    }
    @IBAction func hideTypes(_ sender: NSMenuItem?){
        let del = NSApplication.shared.delegate as! AppDelegate
        del.isShownTypesMenuItem = true
        instrumentTypesContainer.isHidden = true
    }
    @IBAction func showTypes(_ sender: NSMenuItem?){
        let del = NSApplication.shared.delegate as! AppDelegate
        del.isShownTypesMenuItem = false
        instrumentTypesContainer.isHidden = false
    }
    @IBAction func showPayments(_ sender: NSMenuItem?){
        let del = NSApplication.shared.delegate as! AppDelegate
        del.isShownPaymentsMenuItem = false
        paymentsContainer.isHidden = false
    }
    @IBAction func hidePayments(_ sender: NSMenuItem?){
        let del = NSApplication.shared.delegate as! AppDelegate
        del.isShownPaymentsMenuItem = true
        paymentsContainer.isHidden = true
    }
	
    
    @IBAction func showClientDeals(_ sender: NSMenuItem?){
        if let mo = Client.cast(clients.selectedObj){
            let pred = mo.filterValidDeals(for: Date())
            deals.reloadData(pred: Deal.safePred(pred))
        }else{
            dialogOK(msg: "no_client_selected")
        }
		selectTable(deals)
    }
    @IBAction func showInstrumentDeals(_ sender: NSMenuItem?){
        if let mo = Instrument.cast(instruments.selectedObj){
            let pred = mo.filterValidDeals(for: Date())
            deals.reloadData(pred: Deal.safePred(pred))
        }else{
            dialogOK(msg: "no_instrument_selected")
        }
		selectTable(deals)
    }
    @IBAction func showClientAllDeals(_ sender: NSMenuItem?){
        filter(table: deals, bySelected: clients,for:Client.deal)
    }
    @IBAction func showInstrumentAllDeals(_ sender: NSMenuItem?){
		filter(table: deals, bySelected: instruments,for:Instrument.deal)
    }
    @IBAction func showDealPayments(_ sender: NSMenuItem?){
		filter(table: payments, bySelected: deals, for: Payment.deal)
        showPayments(sender)
    }
	private func filter(table: EntitiesTableView,bySelected from:EntitiesTableView, for attr: CoreDataRelatEntry){
        if let mo = from.selectedObj{
			let pred = SafePredicate(ent:table.ent!, expr: attr.equalsOrAny(mo))
            table.reloadData(pred:pred)
        }else{
			switch from.ent?.name{
			case "Client":
				dialogOK(msg: "no_client_selected")
			case "Instrument":
				dialogOK(msg: "no_instrument_selected")
			case "Deal":
				dialogOK(msg: "no_deal_selected")
			case "Payment":
				dialogOK(msg: "no_payment_selected")
			default:
				break
			}
        }
		selectTable(table)
		
    }
	
	private func selectTable(_ table: EntitiesTableView){
		table.selectRowIndexes([0], byExtendingSelection: false)
		table.window?.makeFirstResponder(table)
	}
    
    @IBAction func exportAllCSV(_ sender: NSMenuItem?){
        let url = dialogSave(title: "Export CSV",msg: "Choose destination dir")
        if let dest = url{
            try? FileManager.default.createDirectory(at: dest, withIntermediateDirectories: false, attributes: nil)
            for ent in CoreContext.shared.cache.ents{
                let name = getLocalizedString(for: ent.description.name!)
                let file = dest.appendingPathComponent(name+".csv")
                dialogException(msg: "Failed exporting CSV!",text: name){
                    try OutputStream.doWith(url: file){
                        try ent.exportCSV(stream:$0)
                    }
                }
            }
        }
    }
    @IBAction func exportClientCSV(_ sender: NSMenuItem?){
        exportEntityCVS(ent: "Client")
    }
    @IBAction func exportInstrumentCSV(_ sender: NSMenuItem?){
        exportEntityCVS(ent: "Instrument")
    }
    @IBAction func exportDealCSV(_ sender: NSMenuItem?){
        exportEntityCVS(ent: "Deal")
    }
    @IBAction func exportPaymentCSV(_ sender: NSMenuItem?){
        exportEntityCVS(ent: "Payment")
    }
    
    private func exportEntityCVS(ent name:String){
        let url = dialogSave(title: "Export CSV",msg: "Choose file",allowedFileTypes:["csv"])
        if let dest = url{
            let ent = CoreContext.find(ent:name)!
            let localizedName = getLocalizedString(for: name)
            dialogException(msg: "Failed exporting CSV!",text: localizedName){
                try OutputStream.doWith(url: dest){
                    try ent.exportCSV(stream:$0)
                }
            }
        }
    }
    @IBAction func importArchive(_ sender: NSMenuItem?){
        let url = dialogOpen(title: "Import Archive",msg: "Choose file",allowedFileTypes:["archive"])
        if let dest = url{
            dialogException(msg: "Failed importing archive!"){
                try CoreContext.shared.cache.importArchive(file: dest)
                reloadData()
            }
        }
    }
    @IBAction func importCSV(_ sender: NSMenuItem?){
        let url = dialogOpen(title: "Import CSV",msg: "Choose file",allowedFileTypes:["csv"])
        if let dest = url{
            let id = NSStoryboardSegue.Identifier(rawValue: "csvImportPopover")
            performSegue(withIdentifier: id, sender: dest)
        }
    }
    @IBAction func exportArchive(_ sender: NSMenuItem?){
        let url = dialogSave(title: "Export Archive",msg: "Choose file", allowedFileTypes:["archive"])
        if let dest = url{
            dialogException(msg: "Failed exporting archive!"){
                try OutputStream.doWith(url: dest){
                    try CoreContext.shared.cache.exportArchive(stream:$0)
                }
            }
        }
    }
	func updateUI(for mo:NSManagedObject?){
		tableGroup.load(mo: mo)
	}

    @IBAction func undo(_ sender: NSMenuItem?){
        CoreContext.shared.get().undo()
		updateUI(for: CoreContext.shared.observer.cacheLast?.first)
    }
    @IBAction func redo(_ sender: NSMenuItem?){
        CoreContext.shared.get().redo()
		updateUI(for: CoreContext.shared.observer.cacheLast?.first)
    }
    @IBAction func showSummary(_ sender: NSMenuItem?){
        let id = NSStoryboardSegue.Identifier(rawValue: "incomePopover")
        performSegue(withIdentifier: id, sender: sender)
    }
    @IBAction func showNewTerm(_ sender: NSMenuItem?){
        let id = NSStoryboardSegue.Identifier(rawValue: "newTermPopover")
        performSegue(withIdentifier: id, sender: sender)
    }
    @IBAction func showFilterAccessList(_ sender: NSMenuItem?){
        properties.setLocalizedTitle(title: "FilterAccess")
        properties.reloadData(entries: filter.allAccessEntires + [
            ManualPropertyEntry(localizedName: "Done", type: .button, val: nil){
                [weak self] _,event in
                guard event is PropertyTableEntryValChangeEvent else {return}
                self!.filterRecords(nil)
            }
        ])
    }
    @IBAction func sortRecords(_ sender: NSMenuItem?) {
        properties.setLocalizedTitle(title: "Sorting")
        properties.reloadData(entries: sort.allAccessEntires + [
            ManualPropertyEntry(localizedName:"sort now!", type: .button, val: nil){
                [weak self] _,event in
                guard event is PropertyTableEntryValChangeEvent else {return}
                self!.tableGroup.update(sort:self!.sort)
            }
            ]
        )
    }
    @IBAction func filterRecords(_ sender: NSMenuItem?) {
        properties.setLocalizedTitle(title: "Filters")
        properties.reloadData(entries: filter.allEntries + [
            ManualPropertyEntry(localizedName:"filter now!", type: .button, val: nil){
                [weak self] _,event in
                guard event is PropertyTableEntryValChangeEvent else {return}
                self!.tableGroup.update(filter:self!.filter)
            },
            ManualPropertyEntry(localizedName:"add filters", type: .button, val: nil){
                [weak self] _,event in
                guard event is PropertyTableEntryValChangeEvent else {return}
                self!.showFilterAccessList(nil)
            },
            ManualPropertyEntry(localizedName:"remove filters", type: .button, val: nil){
                [weak self] _,event in
                guard event is PropertyTableEntryValChangeEvent else {return}
                self!.tableGroup.removeAllFilters()
            }
        ])
    }
    
    @IBAction func newClient(_ sender: NSMenuItem) {
        tableGroup.loadNew(for: Client.entity())
    }
    
    @IBAction func newInstrument(_ sender: NSMenuItem) {
        let id = NSStoryboardSegue.Identifier("newInstrumentPopover")
        performSegue(withIdentifier: id, sender: nil)
    }
	@IBAction func deleteInstrument(_ sender: NSMenuItem) {
		if let mo = Instrument.cast(instruments.selectedObj){
			if let error = mo.delete(CoreContext.shared.get()){
				dialogOK(msg: error)
				showInstrumentAllDeals(sender)
			}else{
				instruments.reloadData()
				
			}
		}else{
			dialogOK(msg: "no_instrument_selected")
		}
	}
	
	@IBAction func deleteDeal(_ sender: NSMenuItem) {
		if let mo =  Deal.cast(deals.selectedObj){
			if let error = mo.delete(CoreContext.shared.get()){
				dialogOK(msg: error)
			}else{
				deals.reloadData()
			}
		}else{
			dialogOK(msg: "no_deal_selected")
		}
	}
	
	@IBAction func deleteClient(_ sender: NSMenuItem) {
		if let mo = Client.cast(clients.selectedObj){
			if let error = mo.delete(CoreContext.shared.get()){
				dialogOK(msg: error)
				showClientAllDeals(sender)
			}else{
				clients.reloadData()
			}
		}else{
			dialogOK(msg: "no_client_selected")
		}
	}
	
	@IBAction func newDeal(_ sender: NSMenuItem) {
		newDeal(c: nil, i: nil)
	}
	
	func newDeal(c client:Client?,i instrument:Instrument?) {
		let done = ManualPropertyEntry(localizedName: "Done", type: .button,opts: [.enabled:false])
		let entries = ReusableNewDealPropertyEntries(client:client,instrument:instrument){
			done.set(option: .enabled, val: $0)
		}
		done.onChangeImpl = {
			[weak self] any, event in
			let d = entries.buildNewDeal()
			self!.deals.reloadData()
			self!.deals.selectedObj = d
		}
		
		properties.reloadData(entries: [
			entries.dealId,
			entries.client,
			entries.instruments,
			entries.conflict,
			done
		])
	}
    func reloadData() {
        clients.reloadData()
        deals.reloadData()
        instruments.reloadData()
        instrumentTypes.reloadData()
        payments.reloadData()
		properties.reloadData()
    }
    @IBOutlet weak var payments: EntitiesTableView!
    @IBOutlet weak var properties: CoreDataTable!
    @IBOutlet weak var instruments: InstrumentTableView!
    @IBOutlet weak var deals: DealTableView!
    @IBOutlet weak var clients: ClientTableView!
    @IBOutlet weak var instrumentTypes: EntitiesTableView!
//    private typealias ClientInstrumentPair = (Client,Instrument)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableGroup = TablePair(prop:properties,
							  list:[
								Deal.entity():deals,
								Instrument.entity():instruments,
								InstrumentType.entity():instrumentTypes,
								Payment.entity():payments,
								Client.entity():clients],
                              cntx:CoreContext.shared)
        tableGroup.setDefaultHeaderClickCallback(sort: sort)
        clients.dropValidationCallback = {
            (from:NSManagedObject,to:NSManagedObject)->Bool in
            guard let inst = from as? Instrument else{return false}
            return inst.available
        }
        clients.dropCallback = {
            [weak self] fromRow,fromMO,toRow,toMO in
            if let c = toMO as? Client,let i = fromMO as? Instrument{
				self!.newDeal(c: c, i: i)
            }
        }
		instruments.dropLinkValidationCallback = {
			srcWidget,destMO in
			return Instrument.cast(destMO)!.available
		}
        instruments.dropValidationCallback = {
            (from:NSManagedObject,to:NSManagedObject)->Bool in
			if from is InstrumentType {return true}
            guard from is Client else{return false}
            return Instrument.cast(to)!.available
        }
        instruments.dropCallback = {
            [weak self] fromRow,fromMO,toRow,toMO in
			if let i = toMO as? Instrument{
				if let c = fromMO as? Client{
					self!.newDeal(c: c, i: i)
				}else if let c = fromMO as? InstrumentType{
					i.type = c
					self!.instruments.reloadData(row: toRow)
				}
			}
        }
		
        tableGroup.onChangeImpl = {
            [weak self] val,attr,event in
			if attr.parent.description == Deal.entity(){
				if attr.name == "payment"{
					if event is PropertyTableEntryRelatPressEvent{
						let id = NSStoryboardSegue.Identifier("paymentPopover")
						self!.performSegue(withIdentifier: id, sender: self!.deals)
					}
				}else if attr.name == "status"{
					let deal =  Deal.cast(self!.properties.obj)
					if let insts = deal?.instrument{
						for entry in insts{
							let inst = Instrument.cast(entry)!
							inst.updateAvailablility(cntx: CoreContext.shared)
							if let instRow = self!.instruments.find(obj: inst){
								self!.instruments.reloadData(row: instRow)
							}
						}
					}
					if let client = deal?.client{
						if let clientRow = self!.clients.find(obj: client){
							self!.clients.reloadData(row: clientRow)
						}
					}
					self!.deals.reloadData(row: self!.deals.selectedRow)
				}
			}else if attr.parent.description == Instrument.entity(){
				if attr.name == "available"{
					if event is PropertyTableEntryValChangeEvent{
						self!.instruments.reloadData(row: self!.instruments.selectedRow)
					}
				}
			}
        }
		reloadData()
     }

    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        switch identifier.rawValue {
//            case "changeInstrumentTypePopover":
//                return properties.obj != nil
            case "paymentPopover":
                return deals.selectedObj != nil
//            case "instrumentAccessoriesPopover":
//                return instruments.selectedObj != nil
            default:
                return true
        }
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let id = segue.identifier?.rawValue{
            switch id {
            case "newInstrumentPopover":
                let popover = segue.destinationController as! NewInstrumentViewController
				popover.parentResource = ReloadableCallback(){
					[weak self] in
					self!.instruments.reloadData();
					self!.instrumentTypes.reloadData()
				}
            case "paymentPopover":
                let popover = segue.destinationController as! PaymentsViewController
				popover.deal = Deal.cast(deals.selectedObj)!
                popover.onDismissCallback = {
                    [weak self] in
                    self!.payments.reloadData()
                }
            case "csvImportPopover":
                let popover = segue.destinationController as! CSVImportViewController
                popover.parentResource = self
				popover.dest = (sender as! URL)
			case "newTermPopover":
				let popover = segue.destinationController as! NewTermViewController
				popover.parentResource = self
            default:
                break
            }
        }
    }


}


private extension TablePair{
	func setDefaultHeaderClickCallback(sort group:EntSortGroup){
		for sort in group.all{
			if let l = list[sort.ent.description]{
				l.headerClickCallback = makeHeaderClickCallback(sort: sort, list: l)
			}
		}
	}
	func makeHeaderClickCallback(sort:EntSort,list:EntitiesTableView)-> EntitiesTableView.HeaderClickCallback{
		return {
			[weak self](attrName:String)->Bool in
			guard let attr = list.ent?.find(attr: attrName) else{
				assertionFailure("\(attrName) not found!")
				return false
			}
			if let sortBy = sort.sortBy , sortBy == attr{
				sort.ascending = !sort.ascending
			}else{
				sort.sortBy = attr
			}
			self!.update(sort: sort)
			return true
		}
	}
}

