import UIKit

class LoadingView: UIView {

    var loadingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        self.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
