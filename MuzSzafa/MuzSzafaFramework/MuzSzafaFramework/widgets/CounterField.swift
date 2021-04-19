//
//  CounterField.swift
//  MuzSzafa
//
//  Created by Alagris on 20/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit

open class CounterField: UIView {

	var isEnabled: Bool{
		get{
			return field.isEnabled
		}
		set{
			field.isEnabled = newValue
			stepper.isEnabled = newValue
		}
	}
	
    var contentView:UIView!
    
    var numberValue:Int{
        get{
            return Int(stepper.value)
        }
        set(new){
            stepper.value = Double(new)
            field.text = String(new)
        }
    }
    var onChangeImpl:((Int)->Void)?
    private func onChange(_ val:Int)->Int{
        if let c = onChangeImpl{
            c(val)
        }
        return val
    }
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var field: UITextField!
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        field.text = String(onChange(Int(sender.value)))
    }
    @IBAction func fieldChanged(_ sender: UITextField) {
        if let d = Int(sender.text!){
            stepper.value = Double(onChange(d))
        }else{
            sender.text = "0"
            stepper.value = 0
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = loadFromNib() else {
            return
        }
        setup(view)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadFromNib() else {
            return
        }
        setup(view)
        
    }
    func setup(_ view:UIView){
        contentView = view
        contentView.frame = self.bounds
        self.addSubview(view)
    }
    
    
    func loadFromNib()->UIView?{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CounterField", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
