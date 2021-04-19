//
//  EntitiesTableView.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 28/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import CoreData
import MuzSzafaShared

open class EntitiesTableView: MOListTableView, MOListDataDelegate, EntRecordsTable {
	
    /////////////////////////////
    ///vars
    /////////////////////////////
    public var sort: [NSSortDescriptor]?
    public var pred: SafePredicate?
    public var controller: NSFetchedResultsController<NSManagedObject>?
    /////////////////////////////
    ///init
    /////////////////////////////
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
		dataDelegate = self
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
		dataDelegate = self
    }
    /////////////////////////////
    ///data
    /////////////////////////////
	
    internal func reloadController(){
        if !updateController(){
            controller = makeReqController()
        }
        do{
			assert(ent==nil ? controller == nil : controller != nil)
			assert(pred==nil || pred!.ent==ent!,"Expected \(ent?.name ?? "nil") but got \(controller?.fetchRequest.entity?.name ?? "nil" )")
			assert(controller==nil || ent?.description==controller!.fetchRequest.entity, "Expected \(ent?.name ?? "nil") but got \(controller?.fetchRequest.entity?.name ?? "nil" )")
			
            try controller?.performFetch()
        }catch {
            print("Failed to fetch entity \"\(ent?.description.name ?? "nil" )\"!")
        }
    }
	
	public func reloadData(ent: CoreDataEntity?, pred: SafePredicate?, sort: [NSSortDescriptor]?) {
		if self.ent?.description != ent?.description{
			self.ent = ent
		}
		self.pred = pred
		self.sort = sort
		reloadData()
	}
	
    open override func reloadData() {
        reloadController()
        superReloadData()
    }
    internal func superReloadData(){
        super.reloadData()
    }
}
