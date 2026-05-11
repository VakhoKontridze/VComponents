//
//  VComponentsLocalizationManager.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 23.05.22.
//

import Foundation

/// Object that manages localization in the package.
///
/// `localizationProvider` in `shared` instance can be set to override the localized values.
///
///     nonisolated struct VComponentsLocalizationProviderImplementation: VComponentsLocalizationProvider { ... }
///
///     VComponentsLocalizationManager.shared.localizationProvider = VComponentsLocalizationProviderImplementation()
///
nonisolated public final class VComponentsLocalizationManager: @unchecked Sendable {
    // MARK: Properties - Singleton
    /// Shared instance of `VComponentsLocalizationManager`.
    public static let shared: VComponentsLocalizationManager = .init()
    
    // MARK: Properties - Localization
    /// Localization provider.
    public var localizationProvider: any VComponentsLocalizationProvider {
        get { queue.sync { _localizationProvider } }
        set { queue.sync(flags: .barrier) { _localizationProvider = newValue } }
    }
    private var _localizationProvider: any VComponentsLocalizationProvider = DefaultVComponentsLocalizationProvider()
    
    // MARK: Properties - Queue
    private let queue: DispatchQueue = .init(
        label: "com.vakhtang-kontridze.vcomponents.vcomponents-localization-manager",
        attributes: .concurrent
    )
    
    // MARK: Initializers
    private init() {}
}

/// Localization provider in package.
nonisolated public protocol VComponentsLocalizationProvider {
    /// Localized value for error title in alert.
    var vAlertErrorTitle: String { get }
    
    /// Localized value for `VAlertOKButton`.
    var vAlertOKButtonTitle: String { get }
    
    /// Localized value for `cancel` `VAlertButton`.
    var vAlertCancelButtonTitle: String { get }
}

/// Defaults VComponents localization provider.
nonisolated public struct DefaultVComponentsLocalizationProvider: VComponentsLocalizationProvider, Sendable {
    // MARK: Initializers
    /// Initializes `VComponentsLocalizationProvider`.
    public init() {}
    
    // MARK: VComponents Localization Provider
    public var vAlertErrorTitle: String { "Something Went Wrong" }
    public var vAlertOKButtonTitle: String { "OK" }
    public var vAlertCancelButtonTitle: String { "Cancel" }
}
