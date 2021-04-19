//
//  GenericPicker.swift
//  MuzSzafa
//
//  Created by Alagris on 17/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit

open class GenericPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
	
	var isEnabled: Bool{
		get{
			return isUserInteractionEnabled
		}
		set{
			isUserInteractionEnabled = newValue
		}
	}
	
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let a = array{
            return a.count
        }
        return 0
    }
    
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let a = array{
            if a.count > row{
                selectedRow = row
                onChange(row)
            }else{
                selectedRow = -1
            }
        }
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getNameAt(row)
    }
    
    open func getNameAt(_ row:Int)->String?{
        if let a = array,row<a.count{
            return stringify(a[row])
        }
        return nil
    }
    
    open func stringify(_ element:Any)->String?{
        return stringifyImpl?(element)
    }
    open func onChange(_ row:Int){
        if let s = onChangeImpl{
            return s(row)
        }
    }
    open func queryData()->[Any]?{
        if let s = queryDataImpl{
            return s()
        }
        return array
    }

    open var array:[Any]?
    open var stringifyImpl:((Any)->String)?
    open var onChangeImpl:((Int)->Void)?
    open var queryDataImpl:(()->[Any]?)?
    
    
    open func reloadData() {
        reloadData(queryData())
    }
    private var selectedRow:Int = -1
    open func getSelectedRow()->Int{
        return selectedRow
    }
    open func setSelectedRow(_ row:Int){
        selectedRow = row
        refreshSelection()
    }
    open func getSelected()-> Any?{
        if let a = array{
            if isSelected(){
                return a[selectedRow]
            }
        }
        return nil
    }
    open func refreshSelection(){
        if selectedRow > -1{
            selectRow(selectedRow, inComponent: 0, animated: false)
        }
    }
    
    open func isSelected()->Bool{
        return selectedRow<(array?.count ?? 0) && selectedRow>=0
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
    }

    open func reloadData(_ array:[Any]?) {
        self.array = array
		reloadAllComponents()
    }
    
}
