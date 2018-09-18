import UIKit

class ShopsBuilder {
    static func build() -> UIViewController {
        let router = ShopsRouter()
        let shops = ShopsUseCase(shopsWorker: ShopsWorkerI(), locationWorker: LocationWorker(), saveShopsWorker: SaveShopsWorker(coreData: Container.shared.db))
        let favorite = FavoriteShopUseCase(favoriteWorker: FavoriteShopWorker(coreData: Container.shared.db))
        let viewState = ShopsViewState(shops: nil, type: ShopsViewType.map, title: "TMP title...")
        let presenter = ShopsPresenter(router: router, shops: shops, favorite: favorite, viewState: viewState)
        let controller = ShopsViewController(presenter: presenter)
        presenter.view = controller
        router.viewController = controller
        return controller
    }
}
