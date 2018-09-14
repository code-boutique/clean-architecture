import UIKit
import MapKit

class ShopsContentView: UIView {
    
    var mapView:MKMapView!
    var tableView:UITableView!
    var detailView:UIView!
    var nameLabel:UILabel!
    var favouriteButton:UIButton!
    var nextButton:UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        tableView = UITableView()
        tableView.register(ShopTableViewCell.self, forCellReuseIdentifier: "shop_table_cell")
        //tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        detailView = UIView()
        detailView.alpha = 0.9
        detailView.backgroundColor = .white
        detailView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailView)
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 1
        //TODO: remove
        nameLabel.text = "Shop name"
        detailView.addSubview(nameLabel)
        favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.setImage(UIImage(named: "button_no_favorite"), for: .normal)
        favouriteButton.setImage(UIImage(named: "button_favorite"), for: .selected)
        favouriteButton.setImage(UIImage(named: "button_favorite"), for: .highlighted)
        detailView.addSubview(favouriteButton)
        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(named: "button_next"), for: .normal)
        detailView.addSubview(nextButton)
        NSLayoutConstraint.activate([tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
                                     tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
                                     tableView.topAnchor.constraint(equalTo: self.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     mapView.leftAnchor.constraint(equalTo: self.leftAnchor),
                                     mapView.rightAnchor.constraint(equalTo: self.rightAnchor),
                                     mapView.topAnchor.constraint(equalTo: self.topAnchor),
                                     mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     detailView.leftAnchor.constraint(equalTo: self.leftAnchor),
                                     detailView.rightAnchor.constraint(equalTo: self.rightAnchor),
                                     detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     detailView.heightAnchor.constraint(equalToConstant: 96),
                                     nameLabel.leftAnchor.constraint(equalTo: detailView.leftAnchor, constant: 16),
                                     nameLabel.rightAnchor.constraint(equalTo: favouriteButton.leftAnchor, constant: -16),
                                     nameLabel.topAnchor.constraint(equalTo: detailView.topAnchor),
                                     nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                                     favouriteButton.rightAnchor.constraint(equalTo: nextButton.leftAnchor, constant: -8),
                                     favouriteButton.widthAnchor.constraint(equalToConstant: 40),
                                     favouriteButton.heightAnchor.constraint(equalToConstant: 40),
                                     favouriteButton.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor),
                                     nextButton.rightAnchor.constraint(equalTo: detailView.rightAnchor, constant: -16),
                                     nextButton.widthAnchor.constraint(equalToConstant: 40),
                                     nextButton.heightAnchor.constraint(equalToConstant: 40),
                                     nextButton.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
