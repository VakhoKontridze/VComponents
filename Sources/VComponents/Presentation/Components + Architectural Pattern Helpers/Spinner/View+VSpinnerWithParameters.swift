//
//  View+VContinuousSpinnerWithParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

public import SwiftUI
import VCore

extension View {
    /// Presents `VContinuousSpinner` when `parameters` is non-`nil`.
    ///
    ///     @State private var parameters: VContinuousSpinnerParameters = .init()
    ///
    ///     var body: some View {
    ///         content
    ///             .vContinuousSpinner(parameters: parameters)
    ///     }
    ///
    public func vContinuousSpinner(
        parameters: VContinuousSpinnerParameters?
    ) -> some View {
        self
            .modifier(
                VContinuousSpinnerModifier(
                    parameters: parameters
                )
            )
    }
}

private struct VContinuousSpinnerModifier: ViewModifier {
    // MARK: Properties - Parameters
    private let parameters: VContinuousSpinnerParameters?
    
    @State private var isVisible: Bool = false
    
    // MARK: Subscriptions
    @State private var visibilityTask: Task<Void, Never>?
    
    // MARK: Initializers
    init(
        parameters: VContinuousSpinnerParameters?
    ) {
        self.parameters = parameters
    }
    
    // MARK: Body
    func body(content: Content) -> some View {
        content
            .blocksHitTesting(parameters?.isInteractionEnabled == false)
            .overlay {
                if
                    let parameters,
                    isVisible
                {
                    VContinuousSpinner(appearance: parameters.appearance)
                }
            }
        
            .onChange(of: parameters.visibilityData, initial: true) { (_, newValue) in
                visibilityTask?.cancel()
                visibilityTask = nil
                
                if newValue.isVisible {
                    if let delay: Duration = newValue.delay {
                        visibilityTask = Task {
                            defer { visibilityTask = nil }
                            
                            do {
                                try await Task.sleep(for: delay)
                            } catch {
                                return
                            }
                            
                            isVisible = true
                        }
                        
                    } else {
                        isVisible = true
                    }
                    
                } else {
                    isVisible = false
                }
            }
            .onDisappear {
                visibilityTask?.cancel()
                visibilityTask = nil
            }
    }
}

// Needed, as `VContinuousSpinnerParameters` cannot be equatable
nonisolated private struct VisibilityData: Equatable {
    let isVisible: Bool
    let delay: Duration?
}

nonisolated extension Optional where Wrapped == VContinuousSpinnerParameters {
    fileprivate var visibilityData: VisibilityData {
        .init(
            isVisible: self != nil,
            delay: self?.appearanceDelay
        )
    }
}
