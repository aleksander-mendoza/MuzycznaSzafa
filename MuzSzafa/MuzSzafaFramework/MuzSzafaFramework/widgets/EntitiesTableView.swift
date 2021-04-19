//
//  EntitiesTableView.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 18/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import MuzSzafaShared
import CoreData
open class EntitiesTableView:MOListTableView, MOListDataDelegate, EntRecordsTable {
	
	public func delete(at row: Int) -> Bool {
		if let mo = get(at: row), let cntx = ent?.cntx.get(){
			if let error = mo.autodelete(cntx){
				findViewController()?.dialogOK(msg: error)
			}else{
				try? controller?.performFetch()
				return true
			}
		}
		return false
	}
	
	public func reloadData(ent: CoreDataEntity?, pred: SafePredicate?, sort: [NSSortDescriptor]?) {
		
		self.pred = pred
		self.sort = sort
		reloadData(ent:ent)
	}
	
	public var pred: SafePredicate?
	
    public var sort: [NSSortDescriptor]?
	
    public var controller: NSFetchedResultsController<NSManagedObject>?
	
	public override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		dataDelegate = self
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		dataDelegate = self
	}
	
    internal func reloadController() {
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
        
        super.reloadData()
    }
	
	open override func reloadData() {
		reloadController()
		superReloadData()
	}
	
	internal func superReloadData(){
		super.reloadData()
	}
    
}
