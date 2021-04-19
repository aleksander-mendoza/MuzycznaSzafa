//
//  ToggleButton.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 17/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

open class ToggleButton: NSButton {

    open var textOn:String = getLocalizedString(for:"toggle_yes"){
        didSet{
            if isOn{
                title = textOn
            }
        }
    }
    open var textOff:String = getLocalizedString(for:"toggle_no"){
        didSet{
            if !isOn{
                title = textOff
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
            title = textOn
        }else{
            title = textOff
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
        target = self
        action = #selector(self.toggle(_:))
        updateTitle()
    }
    open override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    @objc open func toggle(_ sender: Any?=nil){
        isOn = !isOn
    }
}

