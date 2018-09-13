//
//  ShopsPresenter.swift
//  clean-architecture
//
//  Created by Alberto on 11/9/18.
//  Copyright © 2018 Code Boutique. All rights reserved.
//

protocol ShopsPresenterProtocol: class {
    func fill()
    func getShops()
    func gotoShopDetail(id:Int)
    func flip()
    func tapShop(id:Int)
}

protocol ShopsView: class {
    func setup(title:String)
    func loading(show:Bool)
    func shops(shopViewState:ShopsViewState)
    func error(error:String)
    func detail(shop:ShopViewModel)
}

struct ShopsViewState {
    let shops:Array<ShopViewModel>?
    let type:ShopsViewType
    let title:String
}

enum ShopsViewType {
    case map, list
}

struct ShopViewModel{
    let id:Int;let name:String;let description:String;let services:Array<String>;let latitude:Double;let longitude:Double;
}

class ShopsPresenter:ShopsPresenterProtocol {
    
    weak var view:ShopsView?
    private let router:ShopsRouterInput
    private let shops:ShopsProtocol
    private var viewState:ShopsViewState
    
    init(router:ShopsRouterInput, shops:ShopsProtocol, viewState:ShopsViewState) {
        self.router = router
        self.shops = shops
        self.viewState = viewState
    }
    
    func fill(){
        view?.setup(title: viewState.title)
    }
    
    func getShops() {
        fill()
        view?.loading(show: true)
        shops.get(output: self)
    }
    
    func gotoShopDetail(id: Int) {
        router.gotoShopDetail(id: id)
    }
    
    func flip() {
        viewState = ShopsViewState(shops: viewState.shops, type: viewState.type == .map ? .list:.map , title: viewState.title)
        view?.shops(shopViewState: viewState)
    }
    
    func tapShop(id:Int){
        let shop = viewState.shops!.first { (shop) -> Bool in
            shop.id == id
        }
        view?.detail(shop: shop!)
    }
}

extension ShopsPresenter: ShopsOutputProtocol {
    
    func onGetShops(shops: Array<Shop>) {
        let mapped = shops.map({ ShopViewModel(id: $0.id, name: $0.name, description: $0.description, services: $0.services, latitude: $0.location.latitude, longitude: $0.location.longitude) })
        viewState = ShopsViewState(shops: mapped, type: viewState.type, title: viewState.title)
        view?.loading(show: false)        
        view?.shops(shopViewState: viewState)
    }
    
    func onGetShopsError(error: Error) {
        view?.loading(show: false)
        view?.error(error: error.localizedDescription)
    }
    
}
