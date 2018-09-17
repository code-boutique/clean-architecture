import UIKit

class ErrorView: UIView {

    var errorLabel: UILabel!
    var reloadButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        self.addSubview(errorLabel)
        
        reloadButton = UIButton()
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.setTitleColor(.red, for: .normal)
        self.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                                     errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
                                     reloadButton.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 15),
                                     reloadButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     reloadButton.widthAnchor.constraint(equalToConstant: 100),
                                     reloadButton.heightAnchor.constraint(equalToConstant: 30)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
