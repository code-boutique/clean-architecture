import CoreData

class FavoriteShopWorker:BaseWorker<Int, Shop, FavoriteShopError> {
    
    private let coreData:CoreData
    
    init(coreData:CoreData) {
        self.coreData = coreData
    }
    
    override func job(input: Int?, completion: @escaping ((WorkerResult<Shop, FavoriteShopError>) -> Void)) {
        coreData.persistentContainer.performBackgroundTask { (context) in
            do {
                let request: NSFetchRequest<ShopCD> = ShopCD.fetchRequest()
                request.predicate = NSPredicate(format: "id == \(input!)")
                if let first = try request.execute().first {
                    first.favorite = !first.favorite
                    try context.save()
                    let stored = Shop(id: Int(first.id),
                                      name: first.name!,
                                      description: first.desc!,
                                      services: first.services!,
                                      location: Location(latitude: first.latitude, longitude: first.longitude),
                                      isFavorite: first.favorite)
                    completion(WorkerResult.success(stored))
                }else{
                    completion(WorkerResult.failure(FavoriteShopError.notFound))
                }
            }catch {
                completion(WorkerResult.failure(FavoriteShopError.store))
            }
        }
    }
}
