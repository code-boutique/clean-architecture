import UIKit.UIViewController

class ShopsBuilder {
    static func build() -> UIViewController {
        let router = ShopsRouter()
        let shops = ShopsUseCase(shopsWorker: ShopsWorkerI(), locationWorker: LocationWorker())
        let viewState = ShopsViewState(shops: nil, type: ShopsViewType.map, title: "TMP title...")
        let presenter = ShopsPresenter(router: router, shops: shops, viewState: viewState)
        let controller = ShopsViewController(presenter: presenter)
        presenter.view = controller
        router.viewController = controller
        return controller
    }
}
