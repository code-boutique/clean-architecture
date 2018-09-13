import XCTest
@testable import cleanArchitecture

class SetupConfigurationTests: XCTestCase {
    
    var sut: SetupUseCase!
    
    override func setUp() {
        super.setUp()
    }
    
    func testGetAppConfigurationSuccess() {
        let downloadWorker = DownloadConfigurationOk()
        let saveWorker = SaveConfigurationOk()
        sut = SetupUseCase(downloadWorker: downloadWorker,
                           saveWorker: saveWorker)
        sut.getAppConfiguration { (result) in
            switch result {
            case .failure(_ ):
                XCTFail()
            case .success(let configutarion):
                XCTAssertNotNil(configutarion)
            }
        }
    }
    
    func testGetAppConfigurationReturnDownloadError() {
        let downloadWorker = DownloadConfigurationFail()
        let saveWorker = SaveConfigurationOk()
        sut = SetupUseCase(downloadWorker: downloadWorker,
                           saveWorker: saveWorker)
        
        sut.getAppConfiguration { (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error == AppConfigurationError.downloadError)
            case .success:
                XCTFail()
            }
        }
    }
    
    func testGetAppConfigurationSaveError() {
        let downloadWorker = DownloadConfigurationOk()
        let saveWorker = SaveConfigurationFail()
        sut = SetupUseCase(downloadWorker: downloadWorker,
                           saveWorker: saveWorker)
        
        sut.getAppConfiguration { (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error == AppConfigurationError.saveError)
            case .success:
                XCTFail()
            }
        }
    }
}

private class DownloadConfigurationOk: DownloadConfigurationWorker {
    func downloadConfiguration(completion: @escaping (Result<AppConfiguration, AppConfigurationError>) -> ()) {
        let shop = Shop(listTitle: "title", detailTitle: "title2")
        let configuration = AppConfiguration(shop: shop)
        completion(Result<AppConfiguration, AppConfigurationError>.success(configuration))
    }
}

private class DownloadConfigurationFail: DownloadConfigurationWorker {
    func downloadConfiguration(completion: @escaping (Result<AppConfiguration, AppConfigurationError>) -> ()) {
        completion(Result<AppConfiguration, AppConfigurationError>.failure(.downloadError))
    }
}

private class SaveConfigurationOk: SaveConfigurationWorker {
    func saveConfiguration(configuration: AppConfiguration) throws {
        
    }
}

private class SaveConfigurationFail: SaveConfigurationWorker {
    func saveConfiguration(configuration: AppConfiguration) throws {
        throw AppConfigurationError.saveError
    }
}
