import Foundation

protocol DownloadConfigurationWorker {
    typealias DownloadErrorCallback = (_ completion: Result<AppConfiguration, AppConfigurationError>) -> ()
    func downloadConfiguration(completion: DownloadErrorCallback)
}
