import XCTest

class LaunchPresenterTests: XCTestCase {
    
    var sut: LaunchPresenter!
    fileprivate var useCase: SetupUseCaseStub!
    fileprivate var router: LaunchRouterSpy!
    
    override func setUp() {
        super.setUp()
        useCase = SetupUseCaseStub()
        router = LaunchRouterSpy()
        sut = LaunchPresenter(setup: useCase,
                              router: router)
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
    
    func testGotoMainScreenWhenConfigurationIsDownloaded() {
        let view = ViewSpy()
        sut.view = view
        sut.sceneReady()
        XCTAssertTrue(view.startLoadingCalled == 1)
        XCTAssertTrue(useCase.getAppConfigurationCalled)
        XCTAssertTrue(view.stopLoadingCalled == 1)
        XCTAssertTrue(router.gotoMainScreenCalled == 1)
    }
    
}

private class LaunchRouterSpy: LaunchRouterInput {
    var gotoMainScreenCalled = 0
    func gotoMainAppScreen() {
        gotoMainScreenCalled += 1
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
