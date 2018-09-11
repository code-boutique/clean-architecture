//
//  ShopContentView.swift
//  clean-architecture
//
//  Created by Alberto on 11/9/18.
//  Copyright © 2018 Code Boutique. All rights reserved.
//

import UIKit

class ShopContentView: UIView {
    
    var nameLabel:UILabel!
    var descriptionLabel:UILabel!
    var servicesLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //TODO: remove texts
        translatesAutoresizingMaskIntoConstraints = false
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.text = "Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text v Sample text v Sample textSample textSample textSample textSample text"
        addSubview(nameLabel)
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "22222 Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text v Sample text v Sample textSample textSample textSample textSample text"
        addSubview(descriptionLabel)
        servicesLabel = UILabel()
        servicesLabel.translatesAutoresizingMaskIntoConstraints = false
        servicesLabel.numberOfLines = 0
        servicesLabel.text = "333 Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text v Sample text v Sample textSample textSample textSample textSample text 333 Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text v Sample text v Sample textSample textSample textSample textSample text"
        addSubview(servicesLabel)
        NSLayoutConstraint.activate([nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                    nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
                                    nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
                                    descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
                                    descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
                                    descriptionLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor),
                                    servicesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                                    servicesLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
                                    servicesLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor),
                                    servicesLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
