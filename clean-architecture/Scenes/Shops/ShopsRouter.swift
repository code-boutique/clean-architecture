//
//  ShopsRouter.swift
//  clean-architecture
//
//  Created by Alberto on 11/9/18.
//  Copyright © 2018 Code Boutique. All rights reserved.
//

import UIKit

protocol ShopsRouterInput {
    func gotoShopDetail(id:Int)
}

class ShopsRouter: ShopsRouterInput {
    
    weak var viewController: UIViewController?
    
    func gotoShopDetail(id: Int) {
        viewController?.navigationController?.pushViewController(ShopDetailViewController(id: id), animated: true)
    }
}
