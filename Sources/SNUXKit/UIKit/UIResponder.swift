//
//  UIResponder.swift
//  
//
//  Created by Jaehong Kang on 2020/01/29.
//

#if canImport(UIKit)
import UIKit

extension UIResponder {
    @discardableResult
    open func present(error: Error) -> Bool {
        guard let self = self as? UIWindow else {
            return next?.present(error: willPresent(error: error)) ?? false
        }

        guard var viewController = self.rootViewController else {
            return false
        }

        while let presentedViewController = viewController.presentedViewController {
            viewController = presentedViewController
        }

        let error = error as NSError

        let alertController = UIAlertController(
            title: error.localizedDescription,
            message: [error.localizedFailureReason, error.localizedRecoverySuggestion].compactMap({ $0 }).joined(separator: "\n"),
            preferredStyle: .alert
        )

        error.localizedRecoveryOptions?.enumerated().forEach { (index, option) in
            alertController.addAction(
                .init(title: option, style: .default, handler: { (_) in
                    error.attemptRecovery(fromError: error, optionIndex: index)
                })
            )
        }

        alertController.addAction(
            .init(
                title: "Cancel",
                style: .cancel
            )
        )

        viewController.present(alertController, animated: true)
        return true
    }

    open func willPresent(error: Error) -> Error {
        if self is UIWindow {
            return UIApplication.shared.delegate?.application(UIApplication.shared, willPresentError: error) ?? error
        } else {
            return error
        }
    }
}

extension UIApplicationDelegate {
    public func application(_ application: UIApplication, willPresentError error: Error) -> Error {
        return error
    }
}

#endif
