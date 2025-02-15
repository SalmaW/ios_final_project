import Foundation

extension Encodable {
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }

        guard
            let dictionary = try? JSONSerialization.jsonObject(
                with: data, options: .allowFragments) as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }
}

struct Status: Codable {
    let code: Int
    let errorMsg: String?
    let error: String?
    let errorData: ErrorData?

    struct ErrorData: Codable {
        let smsTime: Double?
    }

}

struct BusinessError: Error {
    let errorType: NetworkRequestError?
    let errorObject: Status?

    var errorMessage: String? {

        if errorType == .noInternet {
            return "No internet"
        }
        return errorObject?.errorMsg
    }
}

private func handleError(_ error: Error) -> BusinessError {
    switch error {
    case is Swift.DecodingError:
        return BusinessError(
            errorType: .decodingError(error.localizedDescription),
            errorObject: nil)
    case let urlError as URLError:
        return BusinessError(
            errorType: .urlSessionFailed(urlError), errorObject: nil)
    case let error as BusinessError:
        return error
    default:
        return BusinessError(errorType: .unknownError, errorObject: nil)
    }
}

class NetworkManager {
    private var urlSession: URLSession
    static let shared = NetworkManager()

    private init() {
        self.urlSession = URLSession(configuration: .default)
        self.urlSession.configuration.timeoutIntervalForRequest = 60
    }

    func sendRequest<T: Decodable>(
        modelType: T.Type, _ request: any Request,
        completion: @escaping (Result<T, BusinessError>) -> Void
    ) {
        guard
            let urlRequest = request.asURLRequest(baseURL: APIConstants.baseURL)
        else {
            print("ERROR: Failed to construct URLRequest")
            completion(
                .failure(
                    BusinessError(errorType: .unknownError, errorObject: nil)))
            return
        }

        let task = urlSession.dataTask(with: urlRequest) {
            data, response, error in
            if let error = error {
                print("Network Request Error: \(error.localizedDescription)")
                completion(
                    .failure(
                        BusinessError(
                            errorType: .error5xx((error as NSError).code),
                            errorObject: nil)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(
                        .failure(
                            BusinessError(
                                errorType: .error5xx(httpResponse.statusCode),
                                errorObject: nil)))
                    return
                }
            }

            guard let data = data else {
                completion(
                    .failure(
                        BusinessError(
                            errorType: .unknownError, errorObject: nil)))
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(
                    with: data, options: .mutableContainers)
                print("Raw JSON Response: \(jsonResponse)")
                let decodedResponse = try JSONDecoder().decode(
                    modelType, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
                completion(
                    .failure(
                        BusinessError(
                            errorType: .decodingError(
                                error.localizedDescription), errorObject: nil)))
            }
        }
        task.resume()
    }

    public func sendRequestAsync<T: Decodable>(
        modelType: T.Type, _ request: any Request
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            sendRequest(modelType: modelType, request) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
