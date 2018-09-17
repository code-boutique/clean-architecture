import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        launchApp()
        return true
    }
    
    private func launchApp() {
        let downloadWorker = DownloadConfigurationApi()
        let setupUseCase = SetupUseCase(downloadWorker: downloadWorker, saveWorker: SaveWorkerFake())
        let router = LaunchRouter()
        let presenter = LaunchPresenter(setup: setupUseCase,
                                        router: router)
        let controller = LaunchViewController(nibName: nil, bundle: nil, output: presenter)
        presenter.view = controller
        router.viewController = controller
        let nav = UINavigationController(rootViewController: controller)
        nav.setNavigationBarHidden(true, animated: false)
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = .white
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
    }
}

private class SaveWorkerFake: SaveConfigurationWorker {
    func saveConfiguration(configuration: AppConfiguration) throws {
    }
}

private class SetupUseCaseFake: SetupUseCaseProtocol {
    func getAppConfiguration(completion: @escaping (Result<Void, AppConfigurationError>) -> ()) {
        completion(Result<Void, AppConfigurationError>.success(()))
    }
}

