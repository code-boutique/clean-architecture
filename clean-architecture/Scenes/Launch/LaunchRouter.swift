import Foundation
import UIKit

protocol LaunchRouterInput {
    func gotoMainAppScreen()
}

class LaunchRouter: LaunchRouterInput {
    
    weak var viewController: UIViewController?
    
    func gotoMainAppScreen() {
        let router = ShopsRouter()
        let shops = ShopsUseCase(shopsWorker: ShopsWorker2())
        let presenter = ShopsPresenter(router: router, shops: shops)
        let controller = ShopsViewController(presenter: presenter)
        presenter.view = controller
        router.viewController = controller
        viewController!.navigationController?.viewControllers = [controller]
    }
}
