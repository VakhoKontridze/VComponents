//
//  VNavigationViewBackButtonHidden.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/16/21.
//

import SwiftUI

// MARK: - V Navigation View Back Button Hidden
struct VNavigationViewBackButtonHidden: EnvironmentKey {
    static var defaultValue: Bool = true
}

extension EnvironmentValues {
    var vNavigationViewBackButtonHidden: Bool {
        get { self[VNavigationViewBackButtonHidden.self] }
        set { self[VNavigationViewBackButtonHidden.self] = newValue }
    }
}
