//
//  ShopsPresenter.swift
//  clean-architecture
//
//  Created by Alberto on 11/9/18.
//  Copyright © 2018 Code Boutique. All rights reserved.
//

protocol ShopsViewInput: class {
    func gotoShopDetail(id:Int)
}

class ShopsPresenter:ShopsViewInput{
    
    private let router:ShopsRouterInput
    
    init(router:ShopsRouterInput) {
        self.router = router
    }
    
    func gotoShopDetail(id: Int) {
        router.gotoShopDetail(id: id)
    }
}
