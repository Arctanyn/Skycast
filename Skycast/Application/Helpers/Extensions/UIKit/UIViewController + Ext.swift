//
//  UIViewController + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

extension UIViewController {
    var isNavigationController: Bool {
        self is UINavigationController
    }
    
    func showAlert(withTitle title: String?, message: String?, actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func changeNavigationTitle(to title: String, tabBarItemTitle: String? = nil) {
        self.title = title
        navigationController?.tabBarItem.title = tabBarItemTitle ?? title
    }
    
    func animateViewAttachmentWithAppearance(_ animatedView: UIView, topConstraint: NSLayoutConstraint) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.6) { [weak self] in
            animatedView.alpha = 1
            topConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
}

