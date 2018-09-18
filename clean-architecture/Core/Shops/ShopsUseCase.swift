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
    let isFavorite:Bool
    
}

enum ShopsError: Error {
    case network, parsing, timeout, storage, empty
}

class ShopsUseCase:ShopsProtocol  {
    
    private let locationWorker:BaseWorker<Void, Location, LocationError>
    private let shopsWorker:ShopsWorker
    private let saveShopsWorker:BaseWorker<Array<Shop>, Array<Shop>, ShopsError>
    
    init(shopsWorker:ShopsWorker,
         locationWorker:BaseWorker<Void, Location, LocationError>,
         saveShopsWorker:BaseWorker<Array<Shop>, Array<Shop>, ShopsError>) {
        self.shopsWorker = shopsWorker
        self.locationWorker = locationWorker
        self.saveShopsWorker = saveShopsWorker
    }
    
    func get(output:ShopsOutputProtocol) {
        // Callback way
//        locationWorker.execute { (locationResult) in
//            switch locationResult {
//            case .success(let location):
//                self.shopsWorker.execute(input: location, completion: { (shopsResult) in
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
            self.locationWorker.execute()
        }.then { location in
            self.shopsWorker.execute(input: location)
        }.then { shops in
            self.saveShopsWorker.execute(input: shops)
        }.done { result in
            output.onGetShops(shops: result)
        }.catch { error in
            output.onGetShopsError(error: error)
        }
    }
}
