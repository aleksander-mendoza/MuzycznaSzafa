//
//  RepresentationCell.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 25/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import MuzSzafaShared
open class RepresentationCell:GenericTableViewCell{
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "main")
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public init() {
        super.init(style: .subtitle, reuseIdentifier: "main")
    }
    open override func setData(_ data: Any) {
        let repr = getRepresentation(data)
        textLabel?.text = repr.combinePrimary()
        detailTextLabel?.text = repr.combineSecondary()
    }
    
    open func getRepresentation(_ data: Any) -> PropertyRepresentation{
        fatalError("RepresentationCell implementation required!")
    }
}
