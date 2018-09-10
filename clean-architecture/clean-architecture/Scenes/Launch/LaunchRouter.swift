import Foundation
import UIKit

protocol LaunchRouterInput {
    func gotoMainAppScreen()
}

class LaunchRouter: LaunchRouterInput {
    
    weak var viewController: UIViewController?
    
    func gotoMainAppScreen() {
        let controller = ShopLocatorViewController(nibName: nil, bundle: nil)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
