import Foundation
import UIKit

class ShopLocatorViewController: UIViewController {
    
    private var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        loading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.view.addSubview(loading)
        loading.hidesWhenStopped = true
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loading.startAnimating()
    }
    
}
