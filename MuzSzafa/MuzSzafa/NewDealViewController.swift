//
//  NewDealViewController.swift
//  MuzSzafa
//
//  Created by Alagris on 12/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaFramework
import MuzSzafaShared
import CoreData
class NewDealViewController: UIViewController {

	func validate(_ isValid:Bool){
		navigationItem.rightBarButtonItem?.isEnabled = isValid
	}
	
	let entries = ReusableNewDealPropertyEntries(client: nil, instrument: nil)
	
	private func setup(){
		entries.validationCallback = validate(_:)
		navigationItem.rightBarButtonItem?.isEnabled = false
	}
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	@IBOutlet weak var properties: PropertyTable!{
		didSet{
			properties.entries = [
				entries.dealId,
				entries.client,
				entries.instruments,
				entries.conflict
			]
			properties.onRemoveRequestImpl = {
				[weak self] index in
				guard let a = self!.properties.get(at: index.row) else {return}
				var cb:(NSSet) -> ()
				switch a.type{
				case .relatToMany:
					return
				case .relatList:
					return
				case .moList:
					cb = { mos in
						var array = a.value as! [NSManagedObject]
						for mo in mos.allObjects as! [NSManagedObject]{
							array.removeAll(){
								$0 == mo
							}
						}
						a.set(value: array)
						a.onChange(event: PropertyTableEntryMORemoveEvent.singleton)
					}
				default:
					return
				}
				self!.performSegue(withIdentifier: "selectEntity", sender: (a.ent,RelatEditingType.delete,cb))
			}
			properties.onAddRequestImpl = {
				[weak self] index in
				guard let a = self!.properties.get(at: index.row) else {return}
				var cb:(NSSet) -> ()
				switch a.type{
				case .relatToMany:
					return
				case .relatList:
					return
				case .moList:
					cb = { mos in
						a.set(value: (a.value as! [NSManagedObject]) + (mos.allObjects as! [NSManagedObject]))
						a.onChange(event: PropertyTableEntryMOAddEvent.singleton)
					}
				default:
					return
				}
				self!.performSegue(withIdentifier: "selectEntity", sender: (a.ent,RelatEditingType.add,cb))
			}
			properties.onModifyRequestImpl = {
				[weak self] index in
				guard let a = self!.properties.get(at: index.row) else {return}
				var cb:(NSSet) -> ()
				switch a.type{
				case .relat:
					cb = { mos in
						if let  mo = mos.firstElem as! NSManagedObject?{
							let v = a.value as! CellRelatEntry
							a.set(value: CellRelatEntry(mo,v.attr))
							a.onChange()
						}
					}
				default:
					return
				}
				self!.performSegue(withIdentifier: "selectEntity", sender: (a.ent,RelatEditingType.modify,cb))
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func createNewDeal(_ sender: Any) {
		_ = entries.buildNewDeal()
		navigationController?.popViewController(animated: true)
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let id = segue.identifier else{return}
		switch id {
		case "selectEntity":
			let dest = segue.destination as! SelectionViewController
			guard let (ent,type,cb) = sender as? (CoreDataEntity,RelatEditingType,(NSSet) -> ()) else {
				assertionFailure("Wrong type!")
				return
			}
			dest.prepareForManualEditing(ent: ent, type: type, callback: cb)
		default:
			break
		}
	}
}
