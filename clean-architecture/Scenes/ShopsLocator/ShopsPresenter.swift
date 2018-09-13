//
//  ShopsPresenter.swift
//  clean-architecture
//
//  Created by Alberto on 11/9/18.
//  Copyright © 2018 Code Boutique. All rights reserved.
//

protocol ShopsViewInput: class {
    func getShops()
    func gotoShopDetail(id:Int)
}

protocol ShopsView: class {
    func loading(show:Bool)
    func shops(shops:Array<Shop>)
    func error(error:String)
}

class ShopsPresenter:ShopsViewInput {

    weak var view:ShopsView?
    private let router:ShopsRouterInput
    private let shops:ShopsProtocol
    
    init(router:ShopsRouterInput, shops:ShopsProtocol) {
        self.router = router
        self.shops = shops
    }
    
    func gotoShopDetail(id: Int) {
        router.gotoShopDetail(id: id)
    }
}

extension ShopsPresenter: ShopsOutputProtocol {
    
    func getShops() {
        view?.loading(show: true)
        shops.get(output: self)
    }

    func onGetShops(shops: Array<Shop>) {
        view?.loading(show: false)
        view?.shops(shops: shops)
    }
    
    func onGetShopsError(error: Error) {
        view?.loading(show: false)
        view?.error(error: error.localizedDescription)
    }
    
}
