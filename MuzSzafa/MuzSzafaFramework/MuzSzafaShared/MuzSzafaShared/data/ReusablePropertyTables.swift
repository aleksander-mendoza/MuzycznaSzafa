//
//  ReusablePropertyTables.swift
//  MuzSzafaShared
//
//  Created by Alagris on 17/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import CoreData

open class ReusableNewDealPropertyEntries{
	public init(client c:Client?,instrument i:Instrument?,validationCallback:((Bool)->())? = nil){
		validClient = c != nil
		validInstrument = i != nil
		dealId = ManualPropertyEntry(localizedName: "deal_id", type: .string, val: "" as Any, opts: [:], userHelp: CoreDataManualHelp("Help:Deal:id"))
		client = ManualPropertyEntry(localizedName: "client", type: .relat, val: CellRelatEntry(mo:c,attr:Deal.client), opts: [.editable:true], userHelp: CoreDataManualHelp("Help:Deal:client"))
		conflict = ManualPropertyEntry(localizedName: "in_conflict", type: .display, val: nil, opts: [:], userHelp: CoreDataManualHelp("Help:NewDeal:in_conflict"))
		instruments = ManualPropertyEntry(localizedName: "instrument", type: .moList, val: i == nil ? [] : [i!], opts: [.editable:true, .ent:Instrument.ent], userHelp: CoreDataManualHelp("Help:Deal:instrument"))
		
		self.validationCallback = validationCallback
		
		conflict.value = conflicts(maybe:i)
		client.onChangeImpl = clientChange(any:event:)
		dealId.onChangeImpl = dealIdChange(any:event:)
		instruments.onChangeImpl = instrumentsChange(any:event:)
	}
	
	public private(set) var validName:Bool = false
	public private(set) var validClient:Bool
	public private(set) var validInstrument:Bool
	public var validationCallback:((Bool)->())?
	
	public let client:ManualPropertyEntry
	
	public let conflict:ManualPropertyEntry
	
	public let instruments:ManualPropertyEntry
	
	public let dealId:ManualPropertyEntry
	
	
	public func updateDone(){
		validationCallback?(validInstrument && validClient && validName)
	}
	
	func conflicts(_ i:Instrument) -> Bool{
		let pred = Deal.safePred(Deal.filterValid(for: Date()))
		return !(i.deal?.filtered(using:pred.pred).isEmpty ?? true)
	}
	func conflicts(maybe i:Instrument?) -> Bool{
		if let i = i{
			return conflicts(i)
		}
		return false
	}
	func conflicts(instrument:NSManagedObject) -> Bool{
		return conflicts(Instrument.cast(instrument)!)
	}
	func conflicts(instruments:[NSManagedObject]) -> Bool{
		for i in instruments{
			if conflicts(instrument:i){
				return true
			}
		}
		return false
	}
	
	func dealIdChange(any:Any?, event:PropertyTableEntryEvent){
		
		if let new = any as! String?{
			let ent = CoreContext.find(ent:"Deal")!
			validName = validateName(new) && !ent.exists(new)
		}else{
			validName = false
		}
		updateDone()
	}
	func clientChange(any:Any?, event:PropertyTableEntryEvent){
		if event is PropertyTableEntryValChangeEvent{
			let val = any as! CellRelatEntry
			
			validClient = val.mo != nil
			assert(val.mo is Client)
			updateDone()
		}
	}
	
	func instrumentsChange(any:Any?, event:PropertyTableEntryEvent){
		if event is PropertyTableEntryMOEditEvent{
			let mos = any as! [NSManagedObject]
			validInstrument = !mos.isEmpty
			updateDone()
			let c = conflicts(instruments: mos)
			conflict.set(value: c)
		}
	}
	
	
	public var clientValue:Client{
		get{
			return (client.value as! CellRelatEntry).mo as! Client
		}
	}
	
	public var instrumentsValue:[Instrument]{
		get{
			return instruments.value as! [Instrument]
		}
	}
	
	public var dealIdValue:String{
		get{
			return dealId.value as! String
		}
	}
	
	public func buildNewDeal()->Deal{
		let c = clientValue
		let i = instrumentsValue
		let id = dealIdValue
		return Deal.ensureExists(id: id, client: c, instrument: NSSet(array: i))
	}
	
}
