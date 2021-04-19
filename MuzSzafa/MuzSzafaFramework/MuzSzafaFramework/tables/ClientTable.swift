//
//  GenericTable.swift
//  MuzSzafa
//
//  Created by Alagris on 16/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
@objc open class ClientTable:EntitiesTableView {

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

	public override var ent: CoreDataEntity?{
		didSet{
			assert(ent?.description==Client.entity())
		}
	}
}
