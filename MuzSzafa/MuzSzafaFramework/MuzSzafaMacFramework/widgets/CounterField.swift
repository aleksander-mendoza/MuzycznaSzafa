//
//  CounterField.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 02/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa

class CounterField: NSView ,NSTextFieldDelegate{
	
	var isEnabled: Bool{
		set{
			stepper.isEnabled = newValue
			field.isEnabled = newValue
		}
		get{
			return field.isEnabled
		}
	}
	
    @IBOutlet var view: NSView!
    
    @IBOutlet weak var field: NSTextField!{
        didSet{
            field.delegate = self
        }
    }
    @IBOutlet weak var stepper: NSStepper!
    
    var onChangeImpl:((Double)->Void)?
    
    private func onChange(){
        if let c = onChangeImpl{
            c(value)
        }
    }
    @IBAction func stepped(_ sender: NSStepper) {
        let new = stepper.doubleValue
        field.doubleValue = new
        onChange()
    }
    
    private func integerFromField()->Double{
        let str = field.stringValue
        let pure = str.replacingOccurrences(of: ",", with: "")
        let num = Double(pure)
        return num ?? 0
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        value = integerFromField()
        onChange()
    }
    
    var value:Double{
        get{
            return stepper.doubleValue
        }
        set(new){
            var new = new
            if new < stepper.minValue{
                new = stepper.minValue
            }else if new > stepper.maxValue{
                new = stepper.maxValue
            }
            stepper.doubleValue = new
            field.doubleValue = new
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        let bundle = Bundle(for: type(of: self))
        let name = NSNib.Name(rawValue: "CounterField")
        bundle.loadNibNamed(name, owner: self, topLevelObjects: nil)
        self.view.frame = self.bounds
        self.addSubview(view)
    }
    
    
    
}
