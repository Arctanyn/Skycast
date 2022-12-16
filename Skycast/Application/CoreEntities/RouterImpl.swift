//
//  RouterImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

final class RouterImpl: Router {
    
    //MARK: Properties
    
    private var rootController: UINavigationController
    
    var toPresent: UIViewController {
        rootController
    }
    
    //MARK: - Initialization
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
    
    //MARK: - Methods
    
    func setRootModule(_ module: Presentable, hideBar: Bool) {
        let controller = module.toPresent
        rootController.viewControllers = [controller]
        rootController.isNavigationBarHidden = hideBar
    }
    
    func present(_ module: Presentable, animated: Bool) {
        present(module, animated: animated, completion: nil)
    }
    
    func present(_ module: Presentable, animated: Bool, completion: VoidClosure?) {
        let controller = module.toPresent
        rootController.present(controller, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool, completion: VoidClosure?) {
        rootController.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable, animated: Bool) {
        let controller = module.toPresent
        guard !(controller.isNavigationController) else {
            fatalError("")
        }
        rootController.pushViewController(controller, animated: animated)
    }
    
    func popModule(animated: Bool) {
        rootController.popViewController(animated: animated)
    }
    
    func popToRootModule(animated: Bool) {
        rootController.popToRootViewController(animated: animated)
    }
}

