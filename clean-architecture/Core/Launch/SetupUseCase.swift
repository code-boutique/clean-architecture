import Foundation

protocol SetupUseCaseProtocol {
    func getAppConfiguration(completion: @escaping (Result<Void, AppConfigurationError>) -> ())
}

class SetupUseCase: SetupUseCaseProtocol {
    
    private let downloadWorker: DownloadConfigurationWorker
    private let saveWorker: SaveConfigurationWorker
    
    init(downloadWorker: DownloadConfigurationWorker,
         saveWorker: SaveConfigurationWorker) {
        self.downloadWorker = downloadWorker
        self.saveWorker = saveWorker
    }
    
    func getAppConfiguration(completion: @escaping (Result<Void, AppConfigurationError>) -> ()) {
        downloadWorker.downloadConfiguration { (result) in
            switch result {
            case .success(let configuration):
                do {
                    try self.saveWorker.saveConfiguration(configuration: configuration)
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


