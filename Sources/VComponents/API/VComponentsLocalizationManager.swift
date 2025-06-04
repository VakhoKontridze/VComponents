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
///
///     struct SomeLocalizationProvider: VComponentsLocalizationProvider { ... }
///
///     VComponentsLocalizationManager.shared.localizationProvider = SomeLocalizationProvider()
///
public final class VComponentsLocalizationManager: @unchecked Sendable {
    // MARK: Properties - Singleton
    /// Shared instance of `VComponentsLocalizationManager`.
    public static let shared: VComponentsLocalizationManager = .init()
    
    // MARK: Properties - Localization
    private var _localizationProvider: any VComponentsLocalizationProvider = DefaultVComponentsLocalizationProvider()
    
    /// Localization provider. Set to `DefaultVComponentsLocalizationProvider`.
    public var localizationProvider: any VComponentsLocalizationProvider {
        get { queue.sync(execute: { _localizationProvider }) }
        set { queue.sync(flags: .barrier, execute: { _localizationProvider = newValue }) }
    }
    
    // MARK: Properties - Queue
    private let queue: DispatchQueue = .init(
        label: "com.vakhtang-kontridze.vcomponents.vcomponents-localization-manager",
        attributes: .concurrent
    )
    
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
    
    /// Localized value for `cancel` `VAlertButton`.
    var vAlertCancelButtonTitle: String { get }
}

// MARK: - Default VComponents Localization Provider
/// Defaults VComponents localization provider.
public struct DefaultVComponentsLocalizationProvider: VComponentsLocalizationProvider, Sendable {
    // MARK: Initializers
    /// Initializes `VComponentsLocalizationProvider`.
    public init() {}
    
    // MARK: VComponents Localization Provider
    public var vAlertErrorTitle: String { "Something Went Wrong" }
    public var vAlertOKButtonTitle: String { "Ok" }
    public var vAlertCancelButtonTitle: String { "Cancel" }
}
