//
//  PopoverNewMO.swift
//  MuzSzafaShared
//
//  Created by Alagris on 10/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import Foundation
public extension PopoverController{
    func createNewInstrument(type:String,id:String){
        if validateName(type) && validateName(id){
            let t = InstrumentType.ent.ensureExists(type) as! InstrumentType
            let i = Instrument.ent.ensureExists(id) as! Instrument
			i.type = t
            success()
            return
        }
        fail()
    }
    func createNewDeal(inst:NSSet,client:Client,id:String){
        _ = Deal.ensureExists(id: id, client: client, instrument: inst)
		success()
    }
}
