import Foundation
import PromiseKit

enum WorkerResult<R, E> where E: Error {
    case success(R)
    case failure(E)
}

class BaseWorker <I, R, E> where E: Error {
    
    func run(input: I? = nil, completion: @escaping ((WorkerResult<R, E>) -> Void) ) {
        fatalError("Worker is an abstract class, you should implement your own")
    }
    
    final func run(input: I? = nil) -> Promise<R> {
        return Promise { seal in
            self.run(input: input, completion: { (result) in
                switch result {
                case .success(let r):
                    seal.fulfill(r)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
}

//class WorkerSample: BaseWorker<String, String, NoError> {
//    override func run(input: String?, completion: @escaping ((WorkerResult<String, NoError>) -> Void)) {
//        completion(WorkerResult.success("asd"))
//    }
//}
//
//
//enum NoError: Error {}
//
//
//func sampleCase(){
//    let worker = WorkerSample()
//    worker.run(input: "") { (result) in
//        switch result {
//        case .success(let string):
//            break
//        case .failure(let error):
//            break
//        }
//    }
//
//
//    firstly {
//        worker.run()
//    }.done { (result) in
//
//    }.catch { (error) in
//
//    }
//
//    firstly {
//        worker.run(/*here goes the params*/)
//    }.then { (result) in
//        worker.run()
//    }.done { (result) in
//
//    }.catch { (error) in
//
//    }
//}
