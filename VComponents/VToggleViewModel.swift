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
    
    let plainButtonViewModel: VPlainButtonViewModel
    
    // MARK: Initializers
    public init(behavior: Behavior, layout: Layout, colors: Colors) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
        
        self.plainButtonViewModel = .init(
            layout: .init(
                hitAreaOffsetHor: 0,
                hitAreaOffsetVer: 0
            ),
            colors: .init(
                foreground: .init(
                    enabled: .clear,
                    pressed: .clear,
                    disabled: .clear,
                    pressedOpacity: 1
                )
            ),
            fonts: .init()
        )
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
        public let common: Common
        public let rightContent: RightContent
        
        // MARK: Initializers
        public init(common: Common, rightContent: RightContent) {
            self.common = common
            self.rightContent = rightContent
        }
        
        public init() {
            self.init(
                common: .init(),
                rightContent: .init()
            )
        }
    }
    
    public struct Common {
        // MARK: Properties
        public let size: CGSize
        public let thumbDimension: CGFloat
        let animationOffset: CGFloat
        
        // MARK: Initializers
        public init(size: CGSize, thumbDimension: CGFloat) {
            self.size = size
            self.thumbDimension = thumbDimension
            self.animationOffset = {
                let spacing: CGFloat = (size.height - thumbDimension)/2
                let thumnStartPoint: CGFloat = (size.width - thumbDimension)/2
                let offset: CGFloat = thumnStartPoint - spacing
                return offset
            }()
        }
        
        public init() {
            self.init(
                size: .init(width: 51, height: 31),
                thumbDimension: 27
            )
        }
    }
    
    public struct RightContent {
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
        public let fill: StateColors
        public let thumb: StateColors
        
        // MARK: Initializers
        public init(fill: StateColors, thumb: StateColors) {
            self.fill = fill
            self.thumb = thumb
        }
        
        public init() {
            self.init(
                fill: .init(
                    enabledOn: ColorBook.Toggle.Fill.enabledOn,
                    enabledOff: ColorBook.Toggle.Fill.enabledOff,
                    disabled: ColorBook.Toggle.Fill.disabled
                ),
                thumb: .init(
                    enabledOn: ColorBook.Toggle.Thumb.enabledOn,
                    enabledOff: ColorBook.Toggle.Thumb.enabledOff,
                    disabled: ColorBook.Toggle.Thumb.disabled
                )
            )
        }
    }
}

extension VToggleViewModel {
    public struct StateColors {
        // MARK: Properties
        public let enabledOn: Color
        public let enabledOff: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabledOn: Color, enabledOff: Color, disabled: Color) {
            self.enabledOn = enabledOn
            self.enabledOff = enabledOff
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VToggleViewModel.Colors {
    static func fill(isOn: Bool, state: VToggleState, vm: VToggleViewModel) -> Color {
        switch (isOn, state) {
        case (true, .enabled): return vm.colors.fill.enabledOn
        case (false, .enabled): return vm.colors.fill.enabledOff
        case (_, .disabled): return vm.colors.fill.disabled
        }
    }
    
    static func thumb(isOn: Bool, state: VToggleState, vm: VToggleViewModel) -> Color {
        switch (isOn, state) {
        case (true, .enabled): return vm.colors.thumb.enabledOn
        case (false, .enabled): return vm.colors.thumb.enabledOff
        case (_, .disabled): return vm.colors.thumb.disabled
        }
    }
}
