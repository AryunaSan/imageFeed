
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
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let completionOnMainThread: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {
            completionOnMainThread(.failure(AuthErrors.defaultError))
            print("Unable to construct UnsplashOAuthTokenUrl")
            return
        }
        
        let request = URLRequest(url: url)
        
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
            }
        }
        task.resume()
    }
}
