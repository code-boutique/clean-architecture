import Foundation
import UIKit

protocol LaunchRouterInput {
    func gotoMainAppScreen()
}

class LaunchRouter: LaunchRouterInput {
    
    weak var viewController: UIViewController?
    
    func gotoMainAppScreen() {
        let router = ShopsRouter()
        let presenter = ShopsPresenter(router: router)
        let controller = ShopsViewController(presenter: presenter)
        router.viewController = controller
        viewController!.navigationController?.viewControllers = [controller]
    }
}
