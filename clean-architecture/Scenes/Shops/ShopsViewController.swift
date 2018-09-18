import UIKit
import MapKit

class ShopsViewController: ViewController {
    
    private var loadingView: LoadingView!
    private var contentView: ShopsContentView!
    private var errorView: ErrorView!
    private let presenter:ShopsPresenterProtocol!
    private let locationManager:CLLocationManager
    private var shops:Array<ShopViewModel>?
    
    init(presenter:ShopsPresenterProtocol, locationManager:CLLocationManager = CLLocationManager()) {
        self.presenter = presenter
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "navigation_item_list"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(flipViews))
        rightBarButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButton
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "navigation_item_reload"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(reload))
        leftBarButton.isEnabled = false
        self.navigationItem.leftBarButtonItem = leftBarButton
        locationManager.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.mapView.delegate = self
        contentView.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMap)))
        contentView.nextButton.addTarget(self, action: #selector(tapDetail), for: .touchUpInside)
        contentView.favouriteButton.addTarget(self, action: #selector(favorite(sender:)), for: .touchUpInside)
        errorView.reloadButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        presenter.getShops()
    }
    
    override func createViews() {
        contentView = ShopsContentView()
        self.view.addSubview(contentView)
        loadingView = LoadingView()
        self.view.addSubview(loadingView)
        errorView = ErrorView()
        self.view.addSubview(errorView)
        errorView.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setupConstraints() {        
        NSLayoutConstraint.activate([loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     errorView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
    }
    
    @objc func reload() {
        presenter.getShops()
    }
    
    @objc func flipViews() {
        presenter.flip()
    }
    
    @objc func tapMap() {
        presenter.tapMap()
    }
    
    @objc func tapDetail(){
        let id = contentView.nextButton.tag
        presenter.gotoShopDetail(id: id)
    }
    
    @objc func favorite(sender:UIButton) {
        presenter.favorite(id: sender.tag)
    }
}

extension ShopsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shop = shops![indexPath.row]
        let cell = ShopTableViewCell(style: .default, reuseIdentifier: "shop_table_cell")
        cell.nameLabel.text = shop.name
        cell.favouriteButton.isSelected = shop.favorite
        cell.favouriteButton.tag = shop.id
        cell.favouriteButton.addTarget(self, action: #selector(favorite(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension ShopsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.gotoShopDetail(id: shops![indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShopsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! MapAnnotation
        presenter.tapShop(id: annotation.id)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! MapAnnotation
        presenter.gotoShopDetail(id: annotation.id)
    }
}

extension ShopsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            presenter.getShops()
        }
    }
}

extension ShopsViewController: ShopsView {
    
    func setup(title: String) {
        self.title = title
        self.contentView.detailView.isHidden = true
        self.contentView.tableView.isHidden = true
    }
    
    func loading(show: Bool) {
        loadingView.isHidden = !show
        errorView.isHidden = show
        navigationItem.leftBarButtonItem?.isEnabled = !show
    }
    
    func shops(shopViewState: ShopsViewState) {
        self.shops = shopViewState.shops
        contentView.tableView.reloadData()
        var locations = Array<MKPointAnnotation>()
        for shop in self.shops! {
            let location = MapAnnotation(id: shop.id)
            location.coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
            location.title = shop.name
            contentView.mapView.addAnnotation(location)
            locations.append(location)
        }
        contentView.mapView.removeAnnotations(contentView.mapView.annotations)
        contentView.mapView.showAnnotations(locations, animated: true)
        switch shopViewState.type {
        case .map:
            contentView.mapView.isHidden = false
            contentView.tableView.isHidden = true
            contentView.detailView.isHidden = true
            errorView.isHidden = true
        case .list:
            contentView.mapView.isHidden = true
            contentView.detailView.isHidden = true
            contentView.tableView.isHidden = false
            errorView.isHidden = true
        }
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = true
        }
    }
    
    func updateShops(shopViewState: ShopsViewState) {
        self.shops = shopViewState.shops
        contentView.tableView.reloadData()
    }
    
    func detail(shop: ShopViewModel) {
        updateDetail(shop: shop)
        contentView.detailView.isHidden = false
        contentView.mapView.setCenter(CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude), animated: true)
    }
    
    func updateDetail(shop: ShopViewModel){
        contentView.nameLabel.text = shop.name
        contentView.nextButton.tag = shop.id
        contentView.favouriteButton.tag = shop.id
        contentView.favouriteButton.isSelected = shop.favorite
    }
    
    func error(error: String) {
        errorView.isHidden = false
        errorView.errorLabel.text = error
        errorView.reloadButton.setTitle("reload", for: .normal)
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = false
        }
    }
    
    func noLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func hideDetail() {
        contentView.detailView.isHidden = true
    }
}

class MapAnnotation: MKPointAnnotation {
    let id:Int
    init(id:Int) {
        self.id = id
        super.init()
    }
}
