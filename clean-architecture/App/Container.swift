class Container {
    
    static let shared = Container()
    private let coreData:CoreData
    
    private init() {
        coreData = CoreDataEngine()
    }

    var db: CoreData {
        return coreData
    }
}
