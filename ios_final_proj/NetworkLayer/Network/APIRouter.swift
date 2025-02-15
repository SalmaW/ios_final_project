import Foundation

class APIRouter {
    struct GetTrendingGIFs: Request {
        typealias ReturnType = GIFResponse
        var path: String = "/featured"
        var method: RequestType = .get
        var queryParams: [String: Any]?

        init(limit: Int = 10) {
            guard !APIConstants.apiKey    .isEmpty, !APIConstants.clientKey.isEmpty else {
                print("ERROR: Missing API Key or Client Key")
                return
            }
            
            self.queryParams = [
                "key": APIConstants.apiKey,
                "client_key": APIConstants.clientKey,
                "limit": limit,
                "media_filter": "tinygif"
            ]
        }
    }
    
    struct SearchGIFs: Request {
           typealias ReturnType = GIFResponse
           var path: String = "/search"
           var method: RequestType = .get
           var queryParams: [String: Any]?
           
           init(query: String, limit: Int = 10) {
               guard !APIConstants.apiKey.isEmpty, !APIConstants.clientKey.isEmpty else {
                   print("ERROR: Missing API Key or Client Key")
                   return
               }
               
               self.queryParams = [
                   "key": APIConstants.apiKey,
                   "client_key": APIConstants.clientKey,
                   "q": query,
                   "limit": limit,
                   "media_filter": "tinygif"
               ]
           }
       }
   }

