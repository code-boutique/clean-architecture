protocol ShopsPresenterProtocol: class {
    func fill()
    func getShops()
    func gotoShopDetail(id:Int)
    func flip()
    func tapShop(id:Int)
    func favorite(id:Int)
    func tapMap()
}

protocol ShopsView: class {
    func setup(title: String)
    func loading(show: Bool)
    func shops(shopViewState: ShopsViewState)
    func updateShops(shopViewState: ShopsViewState)
    func error(error: String)
    func detail(shop: ShopViewModel)
    func updateDetail(shop: ShopViewModel)
    func hideDetail()
    func noLocationPermission()
}

struct ShopsViewState {
    let shops: Array<ShopViewModel>?
    let type: ShopsViewType
    let title: String
}

enum ShopsViewType {
    case map, list
}

struct ShopViewModel{
    let id:Int
    let name:String
    let description:String
    let services:Array<String>
    let latitude:Double
    let longitude:Double
    let favorite:Bool
}

class ShopsPresenter:ShopsPresenterProtocol {

    weak var view:ShopsView?
    private let router:ShopsRouterInput
    private let shops:ShopsProtocol
    private let favorite:FavoriteShopProtocol
    private var viewState:ShopsViewState
    
    init(router:ShopsRouterInput, shops:ShopsProtocol, favorite:FavoriteShopProtocol, viewState:ShopsViewState) {
        self.router = router
        self.shops = shops
        self.viewState = viewState
        self.favorite = favorite
    }
    
    func fill() {
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
        viewState = ShopsViewState(shops: viewState.shops,
                                   type: viewState.type == .map ? .list:.map ,
                                   title: viewState.title)
        view?.shops(shopViewState: viewState)
    }
    
    func tapShop(id: Int) {
        if let shop = viewState.shops?.first(where: { $0.id == id }) {
            view?.detail(shop: shop)
        }
    }
    
    func favorite(id: Int) {
        if let shop = viewState.shops?.first(where: { $0.id == id }) {            
            favorite.favorite(id: shop.id, output: self)
        }
    }
    
    func tapMap() {
        view?.hideDetail()
    }
}

extension ShopsPresenter: ShopsOutputProtocol {
    
    func onGetShops(shops: Array<Shop>) {
        let mapped = map(shops: shops)
        viewState = ShopsViewState(shops: mapped,
                                   type: viewState.type,
                                   title: viewState.title)
        view?.loading(show: false)        
        view?.shops(shopViewState: viewState)
    }
    
    func onGetShopsError(error: Error) {
        view?.loading(show: false)
        switch error {
        case LocationError.noLocationPermission:
            view?.noLocationPermission()
        default:
            view?.error(error: "Something went wrong, :)")
        }
    }
}

extension ShopsPresenter: FavoriteShopOutputProtocol {
    
    func onFavoriteShop(shop: Shop) {
        let index = viewState.shops?.index(where: { (vm) -> Bool in return vm.id == shop.id })
        if let found = index {
            var shops = viewState.shops!
            let shopViewModel = map(shop: shop)
            shops[found] = shopViewModel
            viewState = ShopsViewState(shops: shops,
                                       type: viewState.type,
                                       title: viewState.title)
            view?.updateDetail(shop: shopViewModel)
            view?.updateShops(shopViewState: viewState)
        }
    }
    
    func onFavoriteShopError(error: FavoriteShopError) {
        switch error {
        case .store:
            view?.error(error: "Cannot mark as favorite")
        case .notFound:
            view?.error(error: "Internal error")
        }
    }
}

// MARK: - mapping
extension ShopsPresenter {
    func map(shop:Shop) -> ShopViewModel {
        return ShopViewModel(id: shop.id,
                      name: shop.name,
                      description: shop.description,
                      services: shop.services,
                      latitude: shop.location.latitude,
                      longitude: shop.location.longitude,
                      favorite: shop.isFavorite)
    }
    
    func map(shops:Array<Shop>) -> Array<ShopViewModel> {
        return shops.map({ (shop) -> ShopViewModel in
            map(shop: shop)
        })
    }
}
