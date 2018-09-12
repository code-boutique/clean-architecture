import Foundation

protocol SaveConfigurationWorker {
    func saveConfiguration(configuration: AppConfiguration) throws
}
