//
//  GenericTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 16/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit

open class GenericTableViewCell: UITableViewCell {

    open override func awakeFromNib() {
        super.awakeFromNib()
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open func setData(_ data:Any){
        fatalError("Override this function")
    }

}
