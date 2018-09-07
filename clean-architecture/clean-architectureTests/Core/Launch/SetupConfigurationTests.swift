import XCTest

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
        sut.getAppConfiguration { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testGetAppConfigurationReturnDownloadError() {
        let downloadWorker = DownloadConfigurationFail()
        let saveWorker = SaveConfigurationOk()
        sut = SetupUseCase(downloadWorker: downloadWorker,
                           saveWorker: saveWorker)
        
        sut.getAppConfiguration { (error) in
            XCTAssertTrue(error == AppConfigurationError.downloadError)
        }
    }
    
    func testGetAppConfigurationSaveError() {
        let downloadWorker = DownloadConfigurationOk()
        let saveWorker = SaveConfigurationFail()
        sut = SetupUseCase(downloadWorker: downloadWorker,
                           saveWorker: saveWorker)
        
        sut.getAppConfiguration { (error) in
            XCTAssertTrue(error == AppConfigurationError.saveError)
        }
    }
}

private class DownloadConfigurationOk: DownloadConfigurationWorker {
    func downloadConfiguration(completion: (AppConfiguration?, AppConfigurationError?) -> ()) {
        let configuration = AppConfiguration()
        completion(configuration, nil)
    }
}

private class DownloadConfigurationFail: DownloadConfigurationWorker {
    func downloadConfiguration(completion: (AppConfiguration?, AppConfigurationError?) -> ()) {
        completion(nil, AppConfigurationError.downloadError)
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
