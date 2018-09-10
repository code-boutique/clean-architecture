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
    
    init(setup: SetupUseCaseProtocol) {
        self.setupUseCase = setup
    }
    
    func sceneReady() {
        view?.startLoading()
        setupUseCase.getAppConfiguration { (configuration) in
            self.view?.stopLoading()
        }
    }
    
}
