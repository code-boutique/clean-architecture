import UIKit

class LaunchViewController: UIViewController {
    
    private var loading: UIActivityIndicatorView!
    
    private let output: LaunchViewOutput
    
    
    init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?,
                  output: LaunchViewOutput) {
        self.output = output
        super.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.view.addSubview(loading)
        loading.hidesWhenStopped = true
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loading.startAnimating()
        
        output.sceneReady()
    }
    
}

extension LaunchViewController: LaunchViewInput {
    func startLoading() {
        self.loading.startAnimating()
    }
    
    func stopLoading() {
        self.loading.stopAnimating()
    }
}

