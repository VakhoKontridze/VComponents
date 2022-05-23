//
//  VComponentsLocalizationService.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 23.05.22.
//

import Foundation

// MARK: - V Components Localization Service
/// Localization Service that can be used to localize the package.
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
    /// Localzied value for `cancel` `VDialogButton`.
    var vDialogCancelButtonTitle: String { get }
    
    /// Localzied value for `ok` `VDialogButton`.
    var vDialogOKButtonTitle: String { get }
}

// MARK: - Default VComponents Localization Provider
/// Defaults VComponents Localization Provider.
public struct DefaultVComponentsLocalizationProvider: VComponentsLocalizationProvider {
    public var vDialogCancelButtonTitle: String { "Cancel" }
    
    public var vDialogOKButtonTitle: String { "Ok" }
}
