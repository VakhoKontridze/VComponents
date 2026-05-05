//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI

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
