import XCTest

class LaunchPresenterTests: XCTestCase {
    
    var sut: LaunchPresenter!
    
    override func setUp() {
        super.setUp()
        sut = LaunchPresenter()
    }
    
    func testLoadingStartSpinningWhenSceneIsReady() {
        let view = ViewSpy()
        sut.view = view
        sut.sceneReady()
        XCTAssertTrue(view.startLoadingCalled == 1)
    }
    
    func testLauncScreenStartConfigurationDownloadWhenSceneIsReady() {
        
    }
    
}

private class ViewSpy: LaunchViewInput {
    
    var startLoadingCalled = 0
    
    func startLoading() {
        startLoadingCalled += 1
    }
    
    func stopLoading() {
        
    }
    
}
