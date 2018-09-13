import Foundation

protocol DownloadConfigurationWorker {
    func downloadConfiguration(completion: @escaping (Result<AppConfiguration, AppConfigurationError>) -> ())
}


