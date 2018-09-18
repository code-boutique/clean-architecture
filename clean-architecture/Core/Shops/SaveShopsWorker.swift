import Foundation
import CoreData

class SaveShopsWorker:BaseWorker<Array<Shop>, Array<Shop>, ShopsError> {
    
    private let coreData:CoreData
    
    init(coreData:CoreData) {
        self.coreData = coreData
    }
    
    override func job(input: Array<Shop>?, completion: @escaping ((WorkerResult<Array<Shop>, ShopsError>) -> Void)) {
        guard let shops = input else {
            completion(WorkerResult.failure(.empty))
            return
        }
        coreData.persistentContainer.performBackgroundTask { (context) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            do {
                for shop in shops {
                    let request: NSFetchRequest<ShopCD> = ShopCD.fetchRequest()
                    request.predicate = NSPredicate(format: "id == \(shop.id)")
                    var shopCD = try request.execute().first
                    if shopCD == nil {
                        shopCD = ShopCD(context: context)
                        shopCD!.id = Int64(shop.id)
                        shopCD!.favorite = false
                    }
                    shopCD!.name = shop.name
                    shopCD!.desc = shop.description
                    shopCD!.services = shop.services
                    shopCD!.latitude = shop.location.latitude
                    shopCD!.longitude = shop.location.longitude
                }
                try context.save()
                
                let request: NSFetchRequest<ShopCD> = ShopCD.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                let shopsCD = try request.execute()
                let mapped = shopsCD.map({ (shopCd) -> Shop in
                    return Shop(id: Int(shopCd.id),
                                name: shopCd.name!,
                                description: shopCd.desc!,
                                services: shopCd.services!,
                                location: Location(latitude: shopCd.latitude, longitude: shopCd.longitude),
                                isFavorite: shopCd.favorite)
                })
                completion(WorkerResult.success(mapped))
            }catch {
                completion(WorkerResult.failure(ShopsError.storage))
            }
        }
    }
}
