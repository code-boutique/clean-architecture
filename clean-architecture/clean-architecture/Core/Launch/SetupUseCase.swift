import Foundation

protocol SetupUseCaseProtocol {
    typealias GetAppConfigurationCallback = (_ completion: Result<Void, AppConfigurationError>) -> ()
    func getAppConfiguration(completion: GetAppConfigurationCallback)
}

class SetupUseCase: SetupUseCaseProtocol {

    private let downloadWorker: DownloadConfigurationWorker
    private let saveWorker: SaveConfigurationWorker
    
    init(downloadWorker: DownloadConfigurationWorker,
         saveWorker: SaveConfigurationWorker) {
        self.downloadWorker = downloadWorker
        self.saveWorker = saveWorker
    }
    
    func getAppConfiguration(completion: (Result<Void, AppConfigurationError>) -> ()) {
        downloadWorker.downloadConfiguration { (result) in
            switch result {
            case .success(let configuration):
                do {
                    try saveWorker.saveConfiguration(configuration: configuration)
                    completion(Result<Void, AppConfigurationError>.success(()))
                } catch (let error) {
                    completion(Result<Void, AppConfigurationError>.failure(error as! AppConfigurationError))
                }
                break
            case .failure(let error):
                completion(Result<Void, AppConfigurationError>.failure(error))
                break
            }
        }
    }
}


