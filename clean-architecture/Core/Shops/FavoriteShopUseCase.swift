import Foundation

enum FavoriteShopError:Error {
    case store, notFound
}

protocol FavoriteShopProtocol {
    func favorite(id:Int, output:FavoriteShopOutputProtocol)
}

protocol FavoriteShopOutputProtocol {
    func onFavoriteShop(shop:Shop)
    func onFavoriteShopError(error:FavoriteShopError)
}

class FavoriteShopUseCase:FavoriteShopProtocol {
    
    private let favoriteWorker:BaseWorker<Int, Shop, FavoriteShopError>
    
    init(favoriteWorker:BaseWorker<Int, Shop, FavoriteShopError>) {
        self.favoriteWorker = favoriteWorker
    }
    
    func favorite(id:Int, output:FavoriteShopOutputProtocol) {
        favoriteWorker.execute(input: id) { (result) in
            switch result{
            case .success(let shop):
                output.onFavoriteShop(shop: shop)
            case .failure(let error):
                output.onFavoriteShopError(error: error)
            }
        }
    }
}
