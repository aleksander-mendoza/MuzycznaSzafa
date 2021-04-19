//
//  DraggableButton.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa

open class DraggableButton: NSButton, NSPasteboardItemDataProvider {

    public weak var source:NSDraggingSource?
    
    public var pboardType:NSPasteboard.PasteboardType? = nil {
        didSet{
            if let t = pboardType{
                registerForDraggedTypes([t])
            }else{
                unregisterDraggedTypes()
            }
        }
        
    }
    
    open func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.link
    }
    
    open func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
        
    }
//    open override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
//        return true
//    }
    
    override open func mouseDown(with theEvent: NSEvent) {
        guard let type = pboardType, let src = source else{
            return
        }
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setDataProvider(self, forTypes: [type])
        
        
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        let dataOfView = dataWithPDF(inside: bounds)
        let imageOfView = NSImage(data: dataOfView)
        draggingItem.setDraggingFrame(bounds, contents:imageOfView)
        
        
        beginDraggingSession(with: [draggingItem], event: theEvent, source: src)
    }

}
