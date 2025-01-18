//
//  UIViewController+Ex.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/19/25.
//

import UIKit

extension UIViewController {
    
    func showAlert(alertModel: AlertMessageModel, Action: (() -> Void)?) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: alertModel.cancelButtonTitle, style: .destructive)
        alert.addAction(cancel)
        
        if let buttonText = alertModel.yesButtonTitle {
            let customAction = UIAlertAction(title: buttonText, style: .default) { _ in
                Action?()
            }
            alert.addAction(customAction)
        }
        present(alert, animated: true)
    }
}
