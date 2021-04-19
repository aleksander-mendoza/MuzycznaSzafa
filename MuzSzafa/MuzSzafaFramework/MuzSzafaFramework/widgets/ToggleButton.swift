//
//  ToggleButton.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
open class ToggleButton: UIButton{

    open var textOn:String = getLocalizedString(for:"toggle_yes"){
        didSet{
            if isOn{
                setTitle(textOn, for: .normal)
            }
        }
    }
    open var textOff:String = getLocalizedString(for:"toggle_no"){
        didSet{
            if !isOn{
                setTitle(textOff, for: .normal)
            }
        }
    }
    open var onChangeImpl: (()->Void)?
    
    private func onChange(){
        if let c = onChangeImpl{
            c()
        }
    }
    
    open var isOn = false {
        didSet(old){
            if old != isOn{
                onChange()
            }
            updateTitle()
        }
    }
    private func updateTitle(){
        if isOn{
            setTitle(textOn, for: .normal)
        }else{
            setTitle(textOff, for: .normal)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    private func initButton(){
        layer.borderWidth = 2.0
        layer.cornerRadius = frame.size.height/2
        addTarget(self, action: #selector(ToggleButton.toggle), for: .touchUpInside)
        updateTitle()
    }
    
    @objc open func toggle(){
        isOn = !isOn
    }
    
    
    
    
    
}
