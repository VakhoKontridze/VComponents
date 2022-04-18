//
//  OptionSet.Elements.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 4/18/22.
//

import Foundation

// MARK: - Option Set Elements
extension OptionSet where RawValue: FixedWidthInteger {
    var elements: [Self] {
        var remainingBits: RawValue = rawValue
        var bitMask: RawValue = 1
        
        let elements: AnySequence<Self> = .init({
            AnyIterator({
                while remainingBits != 0 {
                    defer { bitMask = bitMask &* 2 }
                    
                    if remainingBits & bitMask != 0 {
                        remainingBits = remainingBits & ~bitMask
                        return Self(rawValue: bitMask)
                    }
                }
                
                return nil
            })
        })
        
        return .init(elements)
    }
}
