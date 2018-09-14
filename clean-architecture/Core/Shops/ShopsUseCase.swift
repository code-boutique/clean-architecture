import PromiseKit

protocol ShopsProtocol {
    func get(output:ShopsOutputProtocol)
}

protocol ShopsOutputProtocol {
    func onGetShops(shops:Array<Shop>)
    func onGetShopsError(error:Error)
}

struct Shop {
    let id:Int
    let name:String
    let description:String
    let services:Array<String>
    let location:Location
}

enum ShopsError: Error {
    case network, parsing, timeout
}

class ShopsUseCase:ShopsProtocol  {
    
    private let shopsWorker:ShopsWorker
    private let locationWorker:BaseWorker<Void, Location, LocationError>
    
    init(shopsWorker:ShopsWorker, locationWorker:BaseWorker<Void, Location, LocationError>) {
        self.shopsWorker = shopsWorker
        self.locationWorker = locationWorker
    }
    
    func get(output:ShopsOutputProtocol) {
        // Callback way
//        locationWorker.run { (locationResult) in
//            switch locationResult {
//            case .success(let location):
//                self.shopsWorker.run(input: location, completion: { (shopsResult) in
//                    switch shopsResult {
//                    case .success(let shops):
//                        output.onGetShops(shops: shops)
//                    case .failure(let error):
//                        output.onGetShopsError(error: error)
//                    }
//                })
//            case .failure(let error):
//                output.onGetShopsError(error: error)
//            }
//        }

        //Promise way
        firstly {
            self.locationWorker.run()
        }.then { location in
            self.shopsWorker.run(input: location)
        }.done { result in
            output.onGetShops(shops: result)
        }.catch { error in
            output.onGetShopsError(error: error)
        }
    }
}
