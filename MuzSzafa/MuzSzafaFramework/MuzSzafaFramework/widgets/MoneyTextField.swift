//
//  MoneyTextField.swift
//  MuzSzafa
//
//  Created by Alagris on 13/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
open class MoneyTextField: UITextField,UITextFieldDelegate {

    private var moneyValue:Int64?
    
    func setMoneyValue(_ new:Int64?){
        moneyValue = new
        if let n = new{
            text = moneyToString(n)
        }else{
            text = ""
        }
    }
    func getMoneyValue()->Int64?{
        return moneyValue
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setKeyboard()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setKeyboard()
    }
    
    private func setKeyboard(){
        self.delegate = self
        self.keyboardType = UIKeyboardType.numbersAndPunctuation
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let text = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if let m = parseMoney(text){
            moneyValue = m
            return true
        }
        return false
    }
    
    
}
