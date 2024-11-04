
import Foundation

fileprivate enum AuthErrors: Error {
    case defaultError
}

fileprivate enum NetworkError: Error {
    case codeError
}

fileprivate struct AuthResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let completionOnMainThread: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        guard lastCode != code else {
            completion(.failure(AuthErrors.defaultError))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthErrors.defaultError))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completionOnMainThread(.failure(error))
                print("Error received requesting data")
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completionOnMainThread(.failure(NetworkError.codeError))
                print("Error received requesting data")
                return
            }
            if let data {
                let decoder = JSONDecoder()
                
                do {
                    let authResponse = try decoder.decode(AuthResponse.self, from: data)
                    completionOnMainThread(.success(authResponse.accessToken))
                } catch {
                    completionOnMainThread(.failure(error))
                    print("Failed to decode JSON")
                }
            } else {
                completionOnMainThread(.failure(AuthErrors.defaultError))
                print("Аuthentication error")
                
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
