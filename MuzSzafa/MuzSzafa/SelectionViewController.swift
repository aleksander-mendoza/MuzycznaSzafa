//
//  OverviewViewController.swift
//  MuzSzafa
//
//  Created by Alagris on 17/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaFramework
import MuzSzafaShared
import CoreData
class SelectionViewController: UIViewController {
	
	var ent:CoreDataEntity?
	var pred:SafePredicate?
	var onFinishImpl:((NSSet)->())?
	var allowMultipleSelection:Bool = false
	
	func prepareForRelatEditing(mo:NSManagedObject, type:RelatEditingType, relat:CoreDataRelatEntry){
		ent = relat.destEnt
		
		switch type{
		case .delete:
			assert(relat.isToMany)
			pred = SafePredicate(relat: relat, to: mo)
			allowMultipleSelection = true
			onFinishImpl = { mos in
				let relatSet = relat.get(from: mo) as! NSMutableSet
				for mo in mos{
					relatSet.remove(mo)
				}
			}
		case .add:
			assert(relat.isToMany)
			pred = nil
			allowMultipleSelection = true
			onFinishImpl = { mos in
				let relatSet = relat.get(from: mo) as! NSMutableSet
				for mo in mos{
					relatSet.add(mo)
				}
			}
		case .modify:
			assert(!relat.isToMany)
			pred = nil
			allowMultipleSelection = false
			onFinishImpl = { mos in
				assert(mos.count==1)
				assert(mos.firstElem is NSManagedObject)
				relat.set(for: mo, val: mos.firstElem)
			}
		}
	}
	
	func prepareForManualEditing(ent:CoreDataEntity, type:RelatEditingType, callback:@escaping (NSSet)->()){
		self.ent = ent
		pred = nil
		onFinishImpl = callback
		switch type{
		case .delete:
			allowMultipleSelection = true
		case .add:
			allowMultipleSelection = true
		case .modify:
			allowMultipleSelection = false
		}
	}
	
	@IBAction func done(_ sender: Any) {
		assert(entities.tickable==allowMultipleSelection)
		if allowMultipleSelection{
			onFinishImpl?(entities.tickedMOs)
		}
		navigationController?.popViewController(animated: true)
		
	}
	
	
	private func setAllowMultipleSelection(_ allow:Bool){
		entities.tickable = allow
		if allow{
			entities.onChangeImpl = nil
		}else{
			entities.onChangeImpl = {
				[weak self] row in
				let mo = self!.entities.get(at: row)
				self!.onFinishImpl?(mo==nil ? NSSet() : NSSet(object: mo!))
				self!.navigationController?.popViewController(animated: true)
			}
		}
	}
	
	@IBOutlet weak var entities: EntitiesTableView!{
		didSet{
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		entities.reloadData(ent: ent, pred: pred)
		setAllowMultipleSelection(allowMultipleSelection)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!{
        default:
            break
        }
    }

}
