//
//  MOListTableView.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 15/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import Foundation

import MuzSzafaShared
import CoreData
open class MOListTableView:UITableView, UITableViewDelegate, UITableViewDataSource {
	
	
	
	public func reloadData(ent: CoreDataEntity?) {
		if self.ent?.description != ent?.description{
			self.ent = ent
		}
		reloadData()
	}
	
	open var isEnabled: Bool {
		set{
			isUserInteractionEnabled = newValue
		}
		get{
			return isUserInteractionEnabled
		}
	}
	
	open var allowDeleting:Bool = false
	
	open var dataDelegate:MOListDataDelegate?
	
	public var ent: CoreDataEntity?{
		didSet{
			reloadData()
		}
	}
	
	open var onChangeImpl:((Int)->Void)?
	
	public var tickable: Bool = false
	
	public let tickedMOs = NSMutableSet()
	
	public func isTicked(at row: Int) -> Bool {
		guard let numOfRows = dataDelegate?.numberOfRows() else {
			assertionFailure()
			return false
		}
		guard row < numOfRows else {return false}
		if let mo = dataDelegate?.get(at: row){
			return tickedMOs.contains(mo)
		}
		return false
	}
	
	public func setTicked(at row: Int,_ ticked:Bool) {
		guard let numOfRows = dataDelegate?.numberOfRows() else{return}
		guard row < numOfRows else{return}
		
		guard let e = cellForRow(at: IndexPath(row: row, section: 0)) else{return}
		e.accessoryType = ticked ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
		guard let mo = dataDelegate?.get(at: row) else {return}
		if ticked{
			tickedMOs.add(mo)
		}else{
			tickedMOs.remove(mo)
		}
	}
	
	public func toggleTicked(at row: IndexPath) {
		setTicked(at: row.row, !isTicked(at: row.row))
	}
	
	
	public override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup(){
		delegate = self
		dataSource = self
		registerNib("BasicCell", "BasicCell")
	}
	
	open func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	open func getSelected() -> NSManagedObject? {
		if let i = indexPathForSelectedRow{
			return dataDelegate?.get(at: i.row)
		}
		return nil
	}
	
	
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataDelegate?.numberOfRows() ?? 0
	}
	
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
		if let obj = dataDelegate?.get(at: indexPath.row){
			if let r = ent?.repr{
				r.loadPrimary(mo: obj)
				r.loadSecondary(mo: obj)
				cell.textLabel?.text = r.combinePrimary()
				cell.detailTextLabel?.text = r.combineSecondary()
			}
		}
		return cell
	}
	
	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tickable{
			toggleTicked(at: indexPath)
		}
		onChangeImpl?(indexPath.row)
	}
	
	public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return allowDeleting
	}
	
	open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete && allowDeleting{
			if let d = dataDelegate,d.delete(at: indexPath.row) == true{
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
		}
	}
}
