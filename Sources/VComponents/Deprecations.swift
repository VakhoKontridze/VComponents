//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI

// MARK: - Basic Animation
extension BasicAnimation {
    @available(*, deprecated, renamed: "toSwiftUIAnimation")
    public var asSwiftUIAnimation: Animation { toSwiftUIAnimation }
}
