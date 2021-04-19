//
//  MoneyTextField.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 02/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
class MoneyTextField: NSTextField,NSTextFieldDelegate {

//    private func makeFormatter()->NumberFormatter{
//        let nf = NumberFormatter()
//        nf.maximumFractionDigits = 2
//        return nf
//    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
//        self.formatter = makeFormatter()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
//        self.formatter = makeFormatter()
    }
    
    private var moneyValue:Int64?
    
    func setMoneyValue(_ new:Int64?){
        moneyValue = new
        updateText()
    }
    private func updateText(){
        if let n = moneyValue{
            self.stringValue = moneyToString(n)
        }else{
            self.stringValue = ""
        }
    }
    func getMoneyValue()->Int64?{
        return moneyValue
    }
    var onChangeImpl:((Int64)->Void)?
    private func onChange(){
        if let c = onChangeImpl{
            c(moneyValue!)
        }
    }
    override func controlTextDidChange(_ obj: Notification) {
        let str = self.stringValue
        if let m = looselyParseMoney(str){
            moneyValue = m
            onChange()
        }
    }
}
