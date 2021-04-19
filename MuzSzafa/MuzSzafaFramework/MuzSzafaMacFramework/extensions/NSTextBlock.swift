//
//  NSTextBlock.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 24/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension NSTextBlock{
    func assing(_ other:NSTextBlock){
        let dims:[NSTextBlock.Dimension] = [.height,
                                            .maximumHeight,
                                            .maximumWidth,
                                            .minimumHeight,
                                            .minimumWidth,
                                            .width]
        for dim in dims{
            let val = other.value(for: dim)
            let type = other.valueType(for: dim)
            setValue(val, type: type, for: dim)
        }
        
        setContentWidth(other.contentWidth, type: other.contentWidthValueType)
        
        let edges:[NSRectEdge] = [.maxX,.maxY,.minX,.minY]
        let layers:[NSTextBlock.Layer] = [.border,.margin,.padding]
        for edge in edges{
            for layer in layers{
                let type = other.widthValueType(for:layer , edge: edge)
                let val = other.width(for:layer, edge: edge)
                setWidth(val, type: type, for: layer, edge: edge)
            }
            let color = other.borderColor(for:edge)
            setBorderColor(color, for: edge)
        }

        verticalAlignment = other.verticalAlignment
        
        backgroundColor = other.backgroundColor
        
        
        
        
    }
}
