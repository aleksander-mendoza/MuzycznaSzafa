//
//  ClientViewController.swift
//  MuzycznaSzafa
//
//  Created by Alagris on 03/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaFramework
import MuzSzafaShared
import CoreData
class EntityViewController: UIViewController, Reloadable{

	var mo:NSManagedObject?{
		didSet{
			title = getLocalizedString(for: (mo?.entity.name).or())
		}
	}
	@IBOutlet weak var coreTable: CoreDataTable!{
		didSet{
			coreTable.onChangeImpl = {
				[weak self] val,attr,event in
				if attr == Deal.payment{
					assert(self!.mo is Deal)
					self!.performSegue(withIdentifier: "showPayments", sender: self!.mo)
					return
				}
				
				switch attr.type{
				case .relat:
					if event is PropertyTableEntryValChangeEvent{
						assert(attr is CoreDataRelatEntry)
						self!.performSegue(withIdentifier: "selectEntity", sender: (RelatEditingType.modify,attr))
						return
					}
					fallthrough
				case .relatToMany:
					if let press = event as? PropertyTableEntryRelatPressEvent{
						if let mo = press.mo{
							self!.pushOntoNav(mo: mo)
							return
						}
					}else if event is PropertyTableEntryMOAddEvent{
						assert(attr is CoreDataRelatEntry)
						self!.performSegue(withIdentifier: "selectEntity", sender: (RelatEditingType.add,attr))
						return
					}else if event is PropertyTableEntryMORemoveEvent{
						assert(attr is CoreDataRelatEntry)
						self!.performSegue(withIdentifier: "selectEntity", sender: (RelatEditingType.delete,attr))
						return
					}
				case .relatList:
					fallthrough
				case .moList:
					if let select = event as? PropertyTableEntryMOSelectEvent{
						self!.pushOntoNav(mo: select.mo)
						return
					}
				default:
					break
				}
			}
		}
	}
	
	func pushOntoNav(mo:NSManagedObject?){
		if let mo = mo,let vc = storyboard?.instantiateViewController(withIdentifier: "EntityViewController") as! EntityViewController?{
			vc.mo = mo
			navigationController?.pushViewController(vc, animated: true)
		}
	}

    func reloadData() {
        coreTable.reloadData(ent: mo?.findEnt(in: CoreContext.shared), obj: mo)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!{
		case "showPayments":
			assert(sender is Deal)
			if let deal = sender as? Deal{
				let vc = segue.destination as! PaymentsViewController
				vc.deal = deal
			}
		case "selectEntity":
			guard let mo = mo else {return}
			let vc = segue.destination as! SelectionViewController
			let (type,relat) = sender as! (RelatEditingType,CoreDataRelatEntry)
			vc.prepareForRelatEditing(mo:mo, type: type, relat: relat)
			
        default:
            break
        }
    }
}
