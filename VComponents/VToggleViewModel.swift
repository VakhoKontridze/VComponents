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

// MARK:- Behavior
extension VToggleViewModel {
    public struct Behavior {
        // MARK: Properties
        public let disabledOpacity: Double
        
        // MARK: Initializers
        public init(disabledOpacity: Double) {
            self.disabledOpacity = disabledOpacity
        }
        
        public init() {
            self.init(
                disabledOpacity: 0.25
            )
        }
    }
}

// MARK:- Layout
extension VToggleViewModel {
    public struct Layout {
        // MARK: Properties
        public let right: Right
        
        // MARK: Initializers
        public init(right: Right) {
            self.right = right
        }
        
        public init() {
            self.init(
                right: .init()
            )
        }
    }
    
    public struct Right {
        // MARK: Properties
        public let spacing: CGFloat
        
        // MARK: Initializers
        public init(spacing: CGFloat) {
            self.spacing = spacing
        }
        
        public init() {
            self.init(spacing: 10)
        }
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
                    enabled: ColorBook.Toggle.Fill.enabled,
                    disabled: ColorBook.Toggle.Fill.disabled
                )
            )
        }
    }
}

extension VToggleViewModel {
    public struct StateColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VToggleViewModel.Colors {
    static func toggle(state: VToggleState, vm: VToggleViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.toggle.enabled
        case .disabled: return vm.colors.toggle.disabled
        }
    }
}
