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

struct Location {
    let latitude:Double
    let longitude:Double
}

class ShopsUseCase:ShopsProtocol  {
    
    private let shopsWorker:Worker2<Void, Array<Shop>>
    
    init(shopsWorker:Worker2<Void, Array<Shop>>) {
        self.shopsWorker = shopsWorker
    }
    
    func get(output:ShopsOutputProtocol) {
        firstly {
            shopsWorker.run(input: nil)
        }.done { result in
            output.onGetShops(shops: result)
        }.catch { error in
            output.onGetShopsError(error: error)
        }
    }
}
