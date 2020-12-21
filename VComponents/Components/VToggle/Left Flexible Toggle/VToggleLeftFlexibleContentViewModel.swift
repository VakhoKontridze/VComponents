//
//  VToggleLeftFlexibleContentViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Toggle ViewModel
public struct VToggleLeftFlexibleContentViewModel {
    // MARK: Properties
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    // MARK: Initializers
    public init(behavior: Behavior = .init(), layout: Layout = .init(), colors: Colors = .init()) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
    }
}

// MARK:- Behavior
extension VToggleLeftFlexibleContentViewModel {
    public struct Behavior {
        // MARK: Properties
        public let contentIsClickable: Bool
        public let spaceIsClickable: Bool
        public let animation: Animation
        
        // MARK: Initializers
        public init(
            contentIsClickable: Bool = true,
            spaceIsClickable: Bool = false,
            animation: Animation = Animation.easeIn(duration: 0.1)
        ) {
            self.contentIsClickable = contentIsClickable
            self.spaceIsClickable = spaceIsClickable
            self.animation = animation
        }
    }
}

// MARK:- Layout
extension VToggleLeftFlexibleContentViewModel {
    public struct Layout {
        // MARK: Properties
        public let size: CGSize
        public let thumbDimension: CGFloat
        let animationOffset: CGFloat
        
        // MARK: Initializers
        public init(
            size: CGSize = .init(width: 51, height: 31),
            thumbDimension: CGFloat = 27
        ) {
            self.size = size
            self.thumbDimension = thumbDimension
            self.animationOffset = {
                let spacing: CGFloat = (size.height - thumbDimension)/2
                let thumnStartPoint: CGFloat = (size.width - thumbDimension)/2
                let offset: CGFloat = thumnStartPoint - spacing
                return offset
            }()
        }
    }
}

// MARK:- Colors
extension VToggleLeftFlexibleContentViewModel {
    public struct Colors {
        // MARK: Properties
        public let fill: FillColors
        public let thumb: ThumbColors
        public let content: ContentColors
        
        // MARK: Initializers
        public init(fill: FillColors = .init(), thumb: ThumbColors = .init(), content: ContentColors = .init()) {
            self.fill = fill
            self.thumb = thumb
            self.content = content
        }
    }
}

extension VToggleLeftFlexibleContentViewModel {
    public struct FillColors {
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
        
        public init() {
            self.init(
                enabledOn: ColorBook.Toggle.Fill.enabledOn,
                enabledOff: ColorBook.Toggle.Fill.enabledOff,
                disabled: ColorBook.Toggle.Fill.disabled
            )
        }
    }
    
    public struct ThumbColors {
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
        
        public init() {
            self.init(
                enabledOn: ColorBook.Toggle.Thumb.enabledOn,
                enabledOff: ColorBook.Toggle.Thumb.enabledOff,
                disabled: ColorBook.Toggle.Thumb.disabled
            )
        }
    }
    
    public struct ContentColors {
        // MARK: Properties
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        // MARK: Initializers
        public init(pressedOpacity: Double, disabledOpacity: Double) {
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
        
        public init() {
            self.init(
                pressedOpacity: 0.5,
                disabledOpacity: 0.5
            )
        }
    }
}

// MARK:- Mapping
extension VToggleLeftFlexibleContentViewModel.Colors {
    func fillColor(isOn: Bool, state: VToggleInternalState) -> Color {
        switch (isOn, state) {
        case (true, .enabled): return fill.enabledOn
        case (false, .enabled): return fill.enabledOff
        case (true, .pressed): return fill.enabledOn
        case (false, .pressed): return fill.enabledOff
        case (_, .disabled): return fill.disabled
        }
    }
    
    func thumbColor(isOn: Bool, state: VToggleInternalState) -> Color {
        switch (isOn, state) {
        case (true, .enabled): return thumb.enabledOn
        case (false, .enabled): return thumb.enabledOff
        case (true, .pressed): return thumb.enabledOn
        case (false, .pressed): return thumb.enabledOff
        case (_, .disabled): return thumb.disabled
        }
    }
    
    func contentDisabledOpacity(state: VToggleInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return content.pressedOpacity
        case .disabled: return content.disabledOpacity
        }
    }
}
