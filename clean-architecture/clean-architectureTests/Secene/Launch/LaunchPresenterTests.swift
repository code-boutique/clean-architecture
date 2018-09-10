import XCTest

class LaunchPresenterTests: XCTestCase {
    
    var sut: LaunchPresenter!
    fileprivate var useCase: SetupUseCaseStub!
    
    override func setUp() {
        super.setUp()
        useCase = SetupUseCaseStub()
        sut = LaunchPresenter(setup: useCase)
    }
    
    func testLoadingStartSpinningWhenSceneIsReady() {
        let view = ViewSpy()
        sut.view = view
        sut.sceneReady()
        XCTAssertTrue(view.startLoadingCalled == 1)
    }
    
    func testLauncScreenStartConfigurationDownloadWhenSceneIsReady() {
        let view = ViewSpy()
        sut.view = view
        sut.sceneReady()
        XCTAssertTrue(view.startLoadingCalled == 1)
        XCTAssertTrue(useCase.getAppConfigurationCalled)
        XCTAssertTrue(view.stopLoadingCalled == 1)
    }
    
}

private class SetupUseCaseStub: SetupUseCaseProtocol {
    var getAppConfigurationCalled = false
    func getAppConfiguration(completion: @escaping (AppConfigurationError?) -> ()) {
        getAppConfigurationCalled = true
        completion(nil)
    }
}

private class ViewSpy: LaunchViewInput {
    var startLoadingCalled = 0
    var stopLoadingCalled = 0
    
    func startLoading() {
        startLoadingCalled += 1
    }
    
    func stopLoading() {
        stopLoadingCalled += 1
    }
}
