//
//  InterfaceOrientationChangeObserver.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 21.05.22.
//

import SwiftUI
import Combine

// MARK: - Interface Orientation Change Observer
final class InterfaceOrientationChangeObserver: ObservableObject {
    // MARK: Properties
    @Published var orientation: DeviceInterfaceOrientation?
    private var listener: AnyCancellable?
    
    // MARK: Initializers
    init() {
        self.orientation = .init()
        
        listener = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { _ in DeviceInterfaceOrientation() }
            .assign(to: \.orientation, on: self)
    }
    
    deinit {
        listener?.cancel()
    }
}

// MARK: - Device Interface Orientation
enum DeviceInterfaceOrientation {
    case portrait
    case landscape
    
    init?() {
        switch UIApplication.shared.keyWindowInSingleSceneApplication?.windowScene?.interfaceOrientation {
        case nil: return nil
        case .unknown: return nil
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portrait
        case .landscapeLeft: self = .landscape
        case .landscapeRight: self = .landscape
        @unknown default: return nil
        }
    }
}
