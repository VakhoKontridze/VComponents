//
//  VComponentsLocalizationService.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 23.05.22.
//

import Foundation

// MARK: - VComponents Localization Service
/// Localization service that can be used to localize the package.
///
/// `localizationProvider` in `shared` instance can be set to override the localized values.
public final class VComponentsLocalizationService {
    // MARK: Properties
    /// Shared instance of `VComponentsLocalizationService`.
    public static let shared: VComponentsLocalizationService = .init()
    
    /// Localization provider. Defaults to `DefaultVComponentsLocalizationProvider`.
    public var localizationProvider: VComponentsLocalizationProvider = DefaultVComponentsLocalizationProvider()
    
    // MARK: Initializers
    private init() {}
}

// MARK: - VComponents Localization Provider
/// Localization provider in package.
public protocol VComponentsLocalizationProvider {
    /// Localzied value for `cancel` `VAlertButton`.
    var vAlertCancelButtonTitle: String { get }
    
    /// Localzied value for `ok` `VAlertButton`.
    var vAlertOKButtonTitle: String { get }
    
    /// Localzied value for `cancel` `VActionSheetButton`.
    var vActionSheetCancelButtonTitle: String { get }
    
    /// Localzied value for `ok` `VActionSheetButton`.
    var vActionSheetOKButtonTitle: String { get }
}

// MARK: - Default VComponents Localization Provider
/// Defaults VComponents localization provider.
public struct DefaultVComponentsLocalizationProvider: VComponentsLocalizationProvider {
    public var vAlertCancelButtonTitle: String { "Cancel" }
    public var vAlertOKButtonTitle: String { "Ok" }
    
    public var vActionSheetCancelButtonTitle: String { "Cancel" }
    public var vActionSheetOKButtonTitle: String { "Ok" }
}
