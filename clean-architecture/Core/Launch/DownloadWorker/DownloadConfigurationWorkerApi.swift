import Foundation
import Alamofire

struct AppConfigurationApi: Codable {
    let shops: ShopApi
}

struct ShopApi: Codable {
    let list_title: String
    let detail_title: String
}

class DownloadConfigurationApi: DownloadConfigurationWorker {
    func downloadConfiguration(completion: @escaping (Result<AppConfiguration, AppConfigurationError>) -> ()) {
        Alamofire
            .request("https://shops-locator.herokuapp.com/config",
                     method: .get,
                     parameters: nil,
                     encoding: JSONEncoding.default)
            .responseData { response in
                switch response.result {
                    case .success(let data):
                        do {
                            let configurationApi = try JSONDecoder().decode(AppConfigurationApi.self, from: data)
                            let appConfiguration = self.map(configurationApi)
                            completion(Result.success(appConfiguration))
                        } catch {
                            completion(Result.failure(AppConfigurationError.downloadError))
                        }
                    case .failure:
                        completion(Result.failure(AppConfigurationError.downloadError))
                }
        }
    }
    
    private func map(_ api: AppConfigurationApi) -> AppConfiguration {
        let shop = ShopConfiguration(title: api.shops.detail_title,
                                     titleList: api.shops.list_title)
        return AppConfiguration(shop: shop)
    }
}
