//
//  FileChooser.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 15/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
open class CharacterChooser: NSView,NSTextViewDelegate {

	@IBOutlet weak var text: NSTextView!{
		didSet{
			text.delegate = self
		}
	}
	
	@IBOutlet weak var label: NSTextFieldCell!
	
	open var title:String{
		get{
			return label.stringValue
		}
		set{
			label.stringValue = newValue
		}
	}
	
	open var onChangeImpl:((Character?)->Void)?
	public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
		if let last = replacementString?.last{
			characterValue = last
			onChangeImpl?(characterValue)
			window?.makeFirstResponder(text.nextResponder)
		}
		return false
	}
	public func textDidEndEditing(_ notification: Notification) {
		updateText()
	}
	private func updateText(){
		switch characterValue {
		case "\n":
			text.string = "\"\\n\""
		case "\t":
			text.string = "\"\\t\""
		case "\0":
			text.string = "\"\\0\""
		default:
			text.string = "\"\(characterValue)\""
		}
	}
    @IBOutlet var view: NSView!
    
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
	
	private var characterValue:Character = "\0"
	
	public var charValue:Character{
		get{
			return characterValue
		}
		set{
			characterValue = newValue
			updateText()
		}
	}
	
	
    func setup(){
        let bundle = Bundle(for: type(of: self))
        let name = NSNib.Name(rawValue: "CharacterChooser")
        bundle.loadNibNamed(name, owner: self, topLevelObjects: nil)
        self.view.frame = self.bounds
        self.addSubview(view)
    }
    
    
}
