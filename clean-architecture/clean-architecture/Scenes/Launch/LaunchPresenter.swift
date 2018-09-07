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
    
    func sceneReady() {
        view?.startLoading()
    }
    
}
