//
//  PopUpButtonTableCell.swift
//  MuzSzafaMac
//
//  Created by Alagris on 14/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa

open class PopUpButtonTableCell: NSTableCellView {

    @IBOutlet public weak var popUpButton: NSPopUpButton!{
        didSet{
            update()
        }
    }
    private func update(){
        if let d = dataSource, let p = popUpButton{
            p.removeAllItems()
            p.addItems(withTitles: d())
        }
    }
    public var value:Int{
        get{
            return popUpButton.indexOfSelectedItem
        }
        set{
            popUpButton.selectItem(at: newValue)
        }
    }
    public var stringValue:String?{
        get{
            return popUpButton.titleOfSelectedItem
        }
    }
    
    public var dataSource:(()->[String])?{
        didSet{
            update()
        }
    }
    public var onChangeImpl:((Int,String?)->Void)?
    @IBAction func selected(_ sender: NSPopUpButton) {
        onChangeImpl?(value,stringValue)
    }
    public var onLoadImpl:(()->Void)?
    open override func viewDidMoveToWindow() {
        onLoadImpl?()
    }
}
