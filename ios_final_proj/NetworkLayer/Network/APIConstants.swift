import Foundation

final class APIConstants {
    static let baseURL = "https://tenor.googleapis.com/v2"
    static let apiKey = "AIzaSyDp3xxLkxeQKEG3XfmJJ7Qs1vS0whELSNs"
    static let clientKey = "344166828221-omdtk280mfajpr0smu4j0rop8s4h7p0i.apps.googleusercontent.com"
}

enum HTTPHeaderField: String {
    case authentication = "Authentication"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case authorization = "Authorization"
    case acceptLanguage = "Accept-Language"
    case userAgent = "User-Agent"
}

enum ContentType: String {
    case json = "application/json"
    case xwwwformurlencoded = "application/x-www-form-urlencoded"
}
