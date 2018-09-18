import Foundation
import PromiseKit

/**
 This enum represents the result of a execution for the `BaseWorker`
 
 The result can be:
 - success(let R): if the execution of the worker finished successfully. R is linked to the `BaseWorker` R result
 - failure(let E): if the execution of the worker finished with an error. E is linked to the `BaseWorker` E error
 */
enum WorkerResult<R, E> where E: Error {
    case success(R)
    case failure(E)
}

/**
 This class represents a unit of work.
 
 This class is typed with generics to avoid type casts while passing params and returning results or errors, in the next description
 there are a briefly description of each generic:
    - I: input type received as param while the worker is going to be executed
    - R: result that the worker is going to submit if the execution is succesfully completed
    - E: error that the worker is going to submit if the execution isn't succesfully completed
 
 This unit of work should only be invoked through one of its execute() methods:
    - using promises:
 
```
final func execute(input: I? = nil) -> Promise<R>
```
    - using callbacks
```
final func execute(input: I? = nil, completion: @escaping ((WorkerResult<R, E>) -> Void))
```
 
 The subclass must implement the job() method in which is going to be done the operation that this worker is intented for,
 it can be an sync or async operation, threading should be done by yourself. When the job is completed ensure to call completion function. The result or error is going to be posted to the main thread under the hood
 
 
 Samples:
 
 ```
 enum ReverseError:Error{
    case empty
 }
 
 class ReverseWorker: BaseWorker<String,String,ReverseError> {
    override func job(input: String?, completion: @escaping ((WorkerResult<String, ReverseError>) -> Void)) {
        if let target = input {
            if target.isEmpty {
                completion(WorkerResult.failure(.empty))
            }else {
                completion(WorkerResult.success(String(target.reversed())))
            }
        }else {
            completion(WorkerResult.failure(.empty))
        }
    }
 }
 ```
 
 - using callbacks
```
 func callbackWay() {
    let reverse = ReverseWorker()
    reverse.execute { (locationResult) in
        switch locationResult {
        case .success(let reversed):
            print("result: \(reversed)")
        case .failure(let error):
            print("error: \(error)")
        }
    }
 }
 
```
 
 - using promises
 
 ```
 func promiseWay()  {
    let reverseWorker = ReverseWorker()
    firstly {
        reverseWorker.execute()
    }.done { reversed in
        print("result: \(reversed)")
    }.catch { error in
        print("error: \(error)")
    }
 }
 
 ```
 
 */
class BaseWorker <I, R, E> where E: Error {
    
    private let respondQueue:DispatchQueue
    
    init(respondQueue:DispatchQueue = DispatchQueue.main) {
        self.respondQueue = respondQueue
    }
    
    /**
     It starts the execution of the current worker.
     - Parameters:
        - input: input params
        - completion: completion block to be invoked when the result is available
     */
    final func execute(input: I? = nil, completion: @escaping ((WorkerResult<R, E>) -> Void)) {
        job(input: input) { (result) in
            self.respondQueue.async {
                completion(result)
            }
        }
    }
    
    /**
     It starts the execution of the current worker, this method is only intended to be used with promises.
     - Parameters:
        - input: input params
     */
    final func execute(input: I? = nil) -> Promise<R> {
        return Promise { seal in
            self.execute(input: input, completion: { (result) in
                switch result {
                case .success(let r):
                    seal.fulfill(r)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
    
    /**
     This method must be implemented by the subclass and it represents the job to be done by the worker. It shouldn't be called directly by any client.
     - Parameters:
        - input: input params
        - completion: completion block to be invoked when the result is available
     */
    func job(input: I? = nil, completion: @escaping ((WorkerResult<R, E>) -> Void) ) {
        fatalError("Worker is an abstract class, you should implement your own")
    }
}
