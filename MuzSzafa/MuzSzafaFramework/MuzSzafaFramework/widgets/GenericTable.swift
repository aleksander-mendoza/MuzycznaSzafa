//
//  GenericTable.swift
//  MuzSzafa
//
//  Created by Alagris on 16/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit

@objc open class GenericTable: UITableView, UITableViewDelegate, UITableViewDataSource {

    open var array:[Any]?
    open var onChangeImpl:((Int)->Void)?
    open var queryDataImpl:(()->[Any]?)?
    
    open func onChange(_ row:Int){
        if let s = onChangeImpl{
            return s(row)
        }
    }
    open func queryData()->[Any]?{
        if let s = queryDataImpl{
            return s()
        }
        return nil
    }
    
    open override func reloadData(){
        reloadData(queryData())
    }
    
    open func reloadData(_ array:[Any]?) {
        self.array = array
        super.reloadData()
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
    }
    
    open override var numberOfSections: Int {
        get{
            return 1
        }
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func getSelected() -> Any? {
        if let i = indexPathForSelectedRow, let a = array{
            if i.row < a.count{
                return a[i.row]
            }
        }
        return nil
    }
    
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let a = array{
            return a.count
        }
        return 0
    }
    open override func numberOfRows(inSection section: Int) -> Int {
        return tableView(self, numberOfRowsInSection: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = dequeueReusableCell(withIdentifier: "main", for: indexPath)
        guard let cell = dequeued as? GenericTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GenericTableViewCell<T>.")
        }
        
        cell.setData(array![indexPath.row])
        
        return cell
    }
    
    open override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        return tableView(self, cellForRowAt: indexPath)
        
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onChange(indexPath.row)
    }
    
    
}

