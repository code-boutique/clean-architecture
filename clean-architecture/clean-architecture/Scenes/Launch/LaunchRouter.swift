import Foundation
import UIKit

protocol LaunchRouterInput {
    func gotoMainAppScreen()
}

class LaunchRouter: LaunchRouterInput {
    
    weak var viewController: UIViewController?
    
    func gotoMainAppScreen() {
    }
}
