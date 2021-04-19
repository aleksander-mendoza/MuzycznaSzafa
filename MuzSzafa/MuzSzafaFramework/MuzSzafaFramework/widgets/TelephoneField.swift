//
//  MoneyTextField.swift
//  MuzSzafa
//
//  Created by Alagris on 13/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit

open class TelephoneField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setKeyboard()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setKeyboard()
    }
    
    private func setKeyboard(){
        self.keyboardType = UIKeyboardType.phonePad
    }
    
}
