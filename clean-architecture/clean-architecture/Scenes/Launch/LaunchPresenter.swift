import Foundation

protocol LaunchViewOutput {
    //Better name?
    func sceneReady()
}

protocol LaunchViewInput: class {
    func startLoading()
    func stopLoading()
}

class LaunchPresenter: LaunchViewOutput {
    
    weak var view: LaunchViewInput?
    let setupUseCase: SetupUseCaseProtocol
    let router: LaunchRouterInput
    
    init(setup: SetupUseCaseProtocol,
         router: LaunchRouterInput) {
        self.setupUseCase = setup
        self.router = router
    }
    
    func sceneReady() {
        view?.startLoading()
        setupUseCase.getAppConfiguration { [weak self] (configuration) in
            self?.view?.stopLoading()
            self?.router.gotoMainAppScreen()
        }
    }
    
}
