//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

public import SwiftUI

extension GenericStateModel_EnabledFocusedDisabled_EmptyFilled {
    @available(*, deprecated, message: "Use 'init' with expanded parameters instead")
    public init(
        enabled: Value,
        focused: Value,
        disabled: Value
    ) {
        self.init(
            enabledEmpty: enabled,
            enabledFilled: enabled,
            focusedEmpty: focused,
            focusedFilled: focused,
            disabled: disabled
        )
    }
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension VStretchedButtonAppearance {
    @available(*, unavailable, message: "Use 'labelSpacingType' instead")
    public var labelSpacing: CGFloat {
        get { fatalError() }
        set { fatalError() }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VLoadingStretchedButtonAppearance {
    @available(*, unavailable, message: "Use 'labelSpacingType' instead")
    public var labelSpacing: CGFloat {
        get { fatalError() }
        set { fatalError() }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VStretchedToggleButtonAppearance {
    @available(*, unavailable, message: "Use 'labelSpacingType' instead")
    public var labelSpacing: CGFloat {
        get { fatalError() }
        set { fatalError() }
    }
}

@available(*, unavailable, renamed: "VContinuousSpinnerParameters")
public typealias VSpinnerParameters = VContinuousSpinnerParameters
