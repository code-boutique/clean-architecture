import UIKit

class ShopsViewController: ViewController {
    
    private var loadingView: LoadingView!
    private var contentView: ShopsContentView!
    private var errorView: ErrorView!
    private let presenter:ShopsPresenter
    
    init(presenter:ShopsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        //TODO: change to presenter decision, next lines
        self.title = "Title..."
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_item_list"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(flip))
        loadingView.loadingIndicator.startAnimating()
        self.loadingView.isHidden = true
    }
    
    override func createViews() {
        errorView = ErrorView()
        self.view.addSubview(errorView)
        contentView = ShopsContentView()
        self.view.addSubview(contentView)
        loadingView = LoadingView()
        self.view.addSubview(loadingView)
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
    
    @objc func flip() {
        
    }
}

extension ShopsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO:
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ShopTableViewCell(style: .default, reuseIdentifier: "shop_table_cell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension ShopsViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: hardcoded
        presenter.gotoShopDetail(id: 1)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
