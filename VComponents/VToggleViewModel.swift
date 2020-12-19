//
//  VToggleViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Toggle ViewModel
public struct VToggleViewModel {
    // MARK: Properties
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    // MARK: Initializers
    public init(behavior: Behavior, layout: Layout, colors: Colors) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
    }
    
    public init() {
        self.init(
            behavior: .init(),
            layout: .init(),
            colors: .init()
        )
    }
}

// MARK:- Colors
extension VToggleViewModel {
    public struct Behavior {
        // MARK: Properties
        public let contentIsClickable: Bool
        
        // MARK: Initializers
        public init(contentIsClickable: Bool) {
            self.contentIsClickable = contentIsClickable
        }
        
        public init() {
            self.init(
                contentIsClickable: true
            )
        }
    }
}

// MARK:- Layout
extension VToggleViewModel {
    public struct Layout {
        // MARK: Properties
        public let contentLayout: ContentLayout
        
        // MARK: Initializers
        public init(contentLayout: ContentLayout) {
            self.contentLayout = contentLayout
        }
        
        public init() {
            self.init(
                contentLayout: .right(spacing: 10)
            )
        }
    }
    
    public enum ContentLayout {
        case right(spacing: CGFloat)
        case leftFlexible
    }
}

// MARK:- Colors
extension VToggleViewModel {
    public struct Colors {
        // MARK: Properties
        public let toggle: StateColors
        
        // MARK: Initializers
        public init(toggle: StateColors) {
            self.toggle = toggle
        }
        
        public init() {
            self.init(
                toggle: .init(
                    enabled: ColorBook.Primary.Fill.enabled,
                    disabled: ColorBook.Primary.Fill.disabledLight
                )
            )
        }
    }
    
    public struct StateColors {
        public let enabled: Color
        public let disabled: Color
    }
}
