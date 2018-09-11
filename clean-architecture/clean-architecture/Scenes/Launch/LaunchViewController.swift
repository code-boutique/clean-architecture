import UIKit

class LaunchViewController: ViewController {

    private var errorView:ErrorView!
    private var loadingView:LoadingView!
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
        //TODO: remove this from here, presenter must handle logic of the view
        output.sceneReady()
    }
    
    override func createViews() {
        loadingView = LoadingView()
        self.view.addSubview(loadingView)
        errorView = ErrorView()
        self.view.addSubview(errorView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     errorView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
    }
    
}

extension LaunchViewController: LaunchViewInput {
    func startLoading() {
        loadingView.loadingIndicator.startAnimating()
        errorView.isHidden = true
        //errorView.reloadButton.setTitle("reload", for: .normal)
    }
    
    func stopLoading() {
        loadingView.loadingIndicator.stopAnimating()
    }
}

