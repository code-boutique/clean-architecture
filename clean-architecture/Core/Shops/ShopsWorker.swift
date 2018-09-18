import Foundation
import Alamofire
import PromiseKit
import PMKAlamofire

typealias ShopsWorker = BaseWorker<Location, Array<Shop>, ShopsError>
final class ShopsWorkerI: ShopsWorker {
    
    override func job(input: Location?, completion: @escaping ((WorkerResult<Array<Shop>, ShopsError>) -> Void)) {
        let parameters: Parameters = [
            "latitude": input!.latitude,
            "longitude": input!.longitude
        ]
        Alamofire
            .request("https://shops-locator.herokuapp.com/shops/nearby", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success:
                    do {
                        let parsed = try JSONDecoder().decode([ShopCloud].self, from: response.data!)
                        let mapped = parsed.map({ (shop) -> Shop in
                            Shop(id: shop.id, name: shop.name, description: shop.description, services: shop.services, location: Location(latitude: shop.location.latitude, longitude: shop.location.longitude), isFavorite: false)
                        })
                        completion(WorkerResult.success(mapped))
                    }catch {
                        completion(WorkerResult.failure(ShopsError.parsing))
                    }
                case .failure:
                    completion(WorkerResult.failure(ShopsError.network))
                }
            })
    }
}

fileprivate struct ShopCloud:Decodable {
    let id:Int; let name:String; let description:String; let services:Array<String>; let location:LocationCloud
}

fileprivate struct LocationCloud:Decodable {
    let latitude:Double; let longitude:Double
}
































class Gateway<T>{
    
    func run(resolve:@escaping Resolvable<T>, reject:@escaping Rejectable) {
        assertionFailure("Worker is a class without impl, you should implement your own")
    }
}

//inacabado...
class Middleware {
    func when<T>(gateway:Gateway<T>) -> Middleware {
        Promise { seal in
            gateway.run(resolve: { (any) in
                _ = seal.fulfill(any)
            }, reject: { (error) in
                _ = seal.reject(error)
            })
        }
        return self
    }
    
    func then<T>(resultable:@escaping Resultable<T>){}
}

typealias Resultable<T> = (_ result:T) -> Void
typealias Resolvable<T> = (_ data:T) -> Void
typealias Rejectable = (_ error:Error) -> Void

//no promise kit
class ShopsV2Worker:Gateway<Array<Shop>>{
    override func run(resolve: @escaping (Array<Shop>) -> Void, reject: @escaping Rejectable) {
        let parameters: Parameters = [
            "latitude": 43.0,
            "longitude":-8.0
        ]
        Alamofire
            .request("https://shops-locator.herokuapp.com/shops/nearby", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responseJSON(completionHandler: { (response) in
                if let error = response.error {
                    reject(error)
                }else {
                    do {
                        let parsed = try JSONDecoder().decode([ShopCloud].self, from: response.data!)
                        let mapped = parsed.map({ (shop) -> Shop in
                            Shop(id: shop.id, name: shop.name, description: shop.description, services: shop.services, location: Location(latitude: shop.location.latitude, longitude: shop.location.longitude), isFavorite: false)
                        })
                        resolve(mapped)
                    } catch {
                        reject(error)
                    }
                }
            })
    }
}

class MediatorPromise{
    
}

//func firstly() {
//    let comp = Composition()
//    Composition().firstly(execute: @escaping () -> MediatorPromise) -> Composition
//}

class Composition {
    
    //TODO: retain function blocks
    func firstly(execute: @escaping () -> MediatorPromise) -> Composition {
        return Composition()
    }

    func then<T>(execute: @escaping (_ t:T) -> MediatorPromise) -> Composition {
        return self
    }
    
    func final(execute: @escaping () -> Void) -> Composition {
        return self
    }
    
    func error(error: @escaping (_ error:Error) -> Void) {
        
    }
}


class TestMediator{
    func test()  {
        let composition = Composition()
        composition.firstly {
            MediatorPromise()
        }.then {
            MediatorPromise()
        }.final {
            
        }.error { error in
            
        }
    }
    
    func xx() {
        
    }
}

//TODO: copy

protocol AAThenable {
    associatedtype T
}

extension AAThenable {
    func then<U: AAThenable>(_ body: @escaping(T) throws -> U) -> AAPromise<U.T> {
        return AAPromise()
    }
}

public class AAPromise<T>: AAThenable, AACatchMixin {
    
    
}

protocol AACatchMixin : AAThenable {

}

//func firstly<U: AAThenable>(execute body: () throws -> U) -> AAPromise<U.T> {
//    do {
//        let rp = AAPromise<U.T>()
//        //try body().pipe(to: rp.box.seal)
//        return rp
//    } catch {
//        return AAPromise(/*error: error*/)
//    }
//}










public class Future<T>: Then, CatchMix {
    
}

public class Warranty<T> : Then {
    
}

public protocol CatchMix : Then {
    
}

public protocol Then : AnyObject {
    
    /// The type of the wrapped value
    associatedtype T
//
//    /// `pipe` is immediately executed when this `Thenable` is resolved
//    public func pipe(to: @escaping (PromiseKit.Result<Self.T>) -> Swift.Void)
//
//    /// The resolved result or nil if pending.
//    public var result: PromiseKit.Result<Self.T>? { get }
}


//TODO:
//func first<T>(execute body: () -> Warranty<T>) -> Warranty<T>{
//
//}



func TEST() -> Void {
//    firstly { () -> AAThenable in
//
//    }
}

func TEST_PROMISEKIT(){
    firstly {
        when(resolved: Promise.value("result"))
    }.done { result in
        print("result: \(result)")
    }
}


//class ShopsV2UseCase {
//    func get(){
//        let middleware = Middleware()
//        let gateway = ShopsV2Worker()
//        middleware
//            .when(gateway: gateway)
//            .then(resultable: { result:Array<Shop> in
//
//            })
//    }
//}

//crear promise y bloque que trage promises...(func)


