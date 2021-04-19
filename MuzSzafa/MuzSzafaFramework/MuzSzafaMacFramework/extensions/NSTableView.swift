//
//  NSTableView.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
public extension NSTableView{
    public func removeAllColumns(){
        for col in tableColumns{
            removeTableColumn(col)
        }
    }
    public func removeTableColumn(id:String){
        removeTableColumn(id: NSUserInterfaceItemIdentifier(id))
    }
    public func removeTableColumn(id:NSUserInterfaceItemIdentifier){
        if let c = tableColumn(withIdentifier: id){
            removeTableColumn(c)
        }
    }
    @discardableResult
    public func addTableColumn(id:String) -> NSTableColumn{
        return addTableColumn(id: id, localizedName: id)
    }
    @discardableResult
    public func addTableColumn(id:String,localizedName:String) -> NSTableColumn{
        return addTableColumn(id: NSUserInterfaceItemIdentifier(id), localizedName: localizedName)
    }
    @discardableResult
    public func addTableColumn(id:String,name:String) -> NSTableColumn{
        return addTableColumn(id: NSUserInterfaceItemIdentifier(id), name: name)
    }
    @discardableResult
    public func addTableColumn(id:NSUserInterfaceItemIdentifier,localizedName:String) -> NSTableColumn{
        let loc = getLocalizedString(for: localizedName)
        return addTableColumn(id:id,name:loc)
    }
    @discardableResult
    public func addTableColumn(id:NSUserInterfaceItemIdentifier,name:String) -> NSTableColumn{
        let col = NSTableColumn(identifier: id)
        col.title = name
        addTableColumn(col)
        return col
    }
    public func registerNib(_ nibName:String,
                            _ forCellReuseIdentifier:String){
        registerNib(nibName,forCellReuseIdentifier,bundle:Bundle(for: type(of: self)))
    }
    public func registerNib(_ nibName:String,
                            _ forCellReuseIdentifier:String,
                            bundle:Bundle){
        let id = NSUserInterfaceItemIdentifier(rawValue: forCellReuseIdentifier)
        registerNib(nibName,id,bundle:bundle)
    }
    public func registerNib(_ nibName:String,
                            _ id:NSUserInterfaceItemIdentifier){
        registerNib(nibName,id,bundle:type(of: self))
    }
    public func registerNib(_ nibName:String,
                            _ id:NSUserInterfaceItemIdentifier,
                            bundle:AnyClass){
        registerNib(nibName,id,bundle:Bundle(for: bundle))
    }
    public func registerNib(_ nibName:String,
                            _ id:NSUserInterfaceItemIdentifier,
                            bundle:Bundle){
        let name = NSNib.Name(rawValue: nibName)
        let nib = NSNib(nibNamed: name, bundle: bundle)
        register(nib, forIdentifier: id )
    }
    public func reloadData(row:Int,id:NSUserInterfaceItemIdentifier){
        let col = column(withIdentifier: id)
        reloadData(forRowIndexes: [row], columnIndexes: [col])
    }
    public func reloadData(row:Int){
        let r = ClosedRange.init(0..<numberOfColumns)
        let colSet = IndexSet.init(integersIn: r)
        reloadData(forRowIndexes: [row], columnIndexes:colSet)
    }
}
