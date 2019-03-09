//
//  UIAlerController.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import UIKit

extension UIAlertController {

    static func showErrorAlert(with message: String?, actionTitle: String?, actionHandler: (()->())?, completion:(()->())? = nil, from viewController: UIViewController) {
        showAlert(with: NSLocalizedString("Error", comment: "error name"), message: message, actionButtonTitle: actionTitle, cancelTitle: nil, actionHandler: actionHandler, cancelHandler: nil, completion: completion, from: viewController)
    }
    
    static func showAlert(with title: String?, message: String?, cancelTitle: String?, cancelHandler: (()->())?, completion:(()->())?, from viewController: UIViewController) {
        showAlert(with: title, message: message, actionButtonTitle: nil, cancelTitle: cancelTitle, actionHandler: nil, cancelHandler: cancelHandler, completion: completion, from: viewController)
    }
    
    static func showAlert(with title: String?,
                          message: String?,
                          actionButtonTitle: String?,
                          cancelTitle: String?,
                          actionHandler:(()->())?,
                          cancelHandler:(()->())?,
                          completion:(()->())?,
                          from viewController: UIViewController) {
        let cancelString = cancelTitle ?? NSLocalizedString("Okay", comment: "okay string")
        let title = title ?? NSLocalizedString("Notification", comment: "alert name")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actionButtonTitle = actionButtonTitle {
            let action = UIAlertAction(title: actionButtonTitle, style: .default) { _ in
                actionHandler?()
            }
            
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel) { _ in
            cancelHandler?()
        }
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: completion)
    }

}
