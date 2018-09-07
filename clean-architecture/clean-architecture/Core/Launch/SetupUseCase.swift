import Foundation


enum AppConfigurationError: Error {
    case downloadError
    case saveError
}

struct AppConfiguration {
}

protocol SetupUseCaseProtocol {
    func getAppConfiguration(completion: @escaping (_ error: AppConfigurationError?) -> ())
}

class SetupUseCase: SetupUseCaseProtocol {
    
    private let downloadWorker: DownloadConfigurationWorker
    private let saveWorker: SaveConfigurationWorker
    
    init(downloadWorker: DownloadConfigurationWorker,
         saveWorker: SaveConfigurationWorker) {
        self.downloadWorker = downloadWorker
        self.saveWorker = saveWorker
    }
    
    func getAppConfiguration(completion: @escaping (_ error: AppConfigurationError?) -> ()) {
        downloadWorker.downloadConfiguration { (configuration, error) in
            if let error = error {
                completion(error)
            } else if let configuration = configuration {
                do {
                    try saveWorker.saveConfiguration(configuration: configuration)
                } catch let error {
                    completion(error as? AppConfigurationError)
                }
            }
        }
    }
}

protocol DownloadConfigurationWorker {
    typealias DownloadErrorCallback = (_ configuration: AppConfiguration?, _ error: AppConfigurationError?) -> ()
    func downloadConfiguration(completion: DownloadErrorCallback)
}

protocol SaveConfigurationWorker {
    func saveConfiguration(configuration: AppConfiguration) throws
}
