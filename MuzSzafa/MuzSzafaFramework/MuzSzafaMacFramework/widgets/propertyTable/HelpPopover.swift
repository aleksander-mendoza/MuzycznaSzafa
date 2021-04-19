//
//  HelpPopover.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 23/09/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
open class HelpPopover: NSView {

	private static let minWidth = CGFloat(300)
	private static let minHeight = CGFloat(200)
	private var maxWidth:CGFloat
	private var maxHeight:CGFloat
	public static func present(for anchor:NSView, with help:CoreDataAttrHelp) {
		let screen = NSScreen.main?.frame
		let scale = CGFloat(0.1)
		let width = max((screen?.width ?? 0)*scale, minWidth)
		let height = max((screen?.height ?? 0)*scale, minHeight)
		let viewRect = NSRect(x:CGFloat(0),
							  y:CGFloat(0),
							  width:width,
							  height:height)
		let view = HelpPopover(frame: viewRect)
		view.setHelp(help)
		let controller = NSViewController()
		controller.view = view
		let popover = NSPopover()
		popover.contentViewController = controller
		popover.behavior = .transient
		popover.animates = true
		popover.show(relativeTo: anchor.bounds, of: anchor, preferredEdge: NSRectEdge.maxY)
		
	}
	
	
	@IBOutlet private var view: NSView!
	@IBOutlet private weak var text: NSTextView!{
		didSet{
			updateContent()
		}
	}
	private func updateContent(){
		
		if let text = text{
			let newText = userHelpInfo?.userHelpInfo ?? ""
			text.string = newText
			let h = newText.heightWithConstrainedWidth(width: maxWidth, font: text.font!) + 10
			setFrameSize(NSSize(width: maxWidth, height: min(h,maxHeight)))
		}
	}
	
	override init(frame: CGRect) {
		maxWidth = frame.width
		maxHeight = frame.height
		super.init(frame: frame)
		setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		maxWidth = HelpPopover.minWidth
		maxHeight = HelpPopover.minHeight
		super.init(coder: aDecoder)
		setup()
	}
	
	private var userHelpInfo:CoreDataAttrHelp?
	
	func setHelp(_ userHelpInfo:CoreDataAttrHelp?){
		self.userHelpInfo = userHelpInfo
		updateContent()
	}
	
	func setup(){
		let bundle = Bundle(for: type(of: self))
		let name = NSNib.Name(rawValue: "HelpPopover")
		bundle.loadNibNamed(name, owner: self, topLevelObjects: nil)
		self.view.frame = self.bounds
		self.addSubview(view)
	}
	
}
