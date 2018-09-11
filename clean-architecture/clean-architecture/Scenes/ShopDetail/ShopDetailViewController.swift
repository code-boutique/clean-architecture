//
//  ShopDetailViewController.swift
//  clean-architecture
//
//  Created by Alberto on 11/9/18.
//  Copyright © 2018 Code Boutique. All rights reserved.
//

import UIKit

class ShopDetailViewController: ViewController {
    
    private var loadingView: LoadingView!
    private var contentView: ShopContentView!
    private var errorView: ErrorView!
    private let id:Int
    
    init(id:Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: change to presenter decision, next lines
        self.title = "Title2..."
        loadingView.loadingIndicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "button_no_favorite"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(like))
    }
    
    override func createViews() {
        errorView = ErrorView()
        self.view.addSubview(errorView)
        contentView = ShopContentView()
        self.view.addSubview(contentView)
        loadingView = LoadingView()
        self.view.addSubview(loadingView)
        
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
    
    @objc private func like() {
        
    }

}
