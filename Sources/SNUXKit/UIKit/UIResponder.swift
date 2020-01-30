//
//  UIResponder.swift
//  
//
//  Created by Jaehong Kang on 2020/01/29.
//  Copyright © 2020 Sinoru. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#if canImport(UIKit)
import UIKit

extension UIResponder {
    @discardableResult
    @objc
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

    @objc
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
