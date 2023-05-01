//
//  VComponentsLocalizationManager.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 23.05.22.
//

import Foundation

// MARK: - VComponents Localization Manager
/// Object that manages localization in the package.
///
/// `localizationProvider` in `shared` instance can be set to override the localized values.
public final class VComponentsLocalizationManager {
    // MARK: Properties
    /// Shared instance of `VComponentsLocalizationService`.
    public static let shared: VComponentsLocalizationManager = .init()
    
    /// Localization provider. Set to `DefaultVComponentsLocalizationProvider`.
    public var localizationProvider: any VComponentsLocalizationProvider = DefaultVComponentsLocalizationProvider()
    
    // MARK: Initializers
    private init() {}
}

// MARK: - VComponents Localization Provider
/// Localization provider in package.
public protocol VComponentsLocalizationProvider {
    /// Localized value for error title in alert.
    var vAlertErrorTitle: String { get }
    
    /// Localized value for `VAlertOKButton`.
    var vAlertOKButtonTitle: String { get }
    
    /// Localized value for `VAlertCancelButton`.
    var vAlertCancelButtonTitle: String { get }
}

// MARK: - Default VComponents Localization Provider
/// Defaults VComponents localization provider.
public struct DefaultVComponentsLocalizationProvider: VComponentsLocalizationProvider {
    // MARK: Initializers
    /// Initializes `VComponentsLocalizationProvider`.
    public init() {}
    
    // MARK: VComponents Localization Provider
    public var vAlertErrorTitle: String { "Something Went Wrong" }
    public var vAlertOKButtonTitle: String { "Ok" }
    public var vAlertCancelButtonTitle: String { "Cancel" }
}
