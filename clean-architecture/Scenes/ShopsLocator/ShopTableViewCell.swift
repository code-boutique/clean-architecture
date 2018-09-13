//
//  ShopTableViewCell.swift
//  clean-architecture
//
//  Created by Alberto on 11/9/18.
//  Copyright © 2018 Code Boutique. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    
    var nameLabel:UILabel!
    var favouriteButton:UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 1
        //TODO: remove
        nameLabel.text = "Shop name"
        contentView.addSubview(nameLabel)
        favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.setImage(UIImage(named: "button_no_favorite"), for: .normal)
        favouriteButton.setImage(UIImage(named: "button_favorite"), for: .selected)
        favouriteButton.setImage(UIImage(named: "button_favorite"), for: .highlighted)
        contentView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
                                     nameLabel.rightAnchor.constraint(equalTo: favouriteButton.leftAnchor, constant: -16),
                                     nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     favouriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
                                     favouriteButton.widthAnchor.constraint(equalToConstant: 40),
                                     favouriteButton.heightAnchor.constraint(equalToConstant: 40),
                                     favouriteButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
