
import Foundation

fileprivate struct AuthResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    var authToken: String? {
            get {
                OAuth2TokenStorage().token
            }
            set {
                OAuth2TokenStorage().token = newValue
            }
        }

    private enum NetworkError: Error {
            case codeError
        }
    private enum AuthErrors: Error {
        case defaultError
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let completionOnMainThread: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let baseURL = URL(string: "https://unsplash.com") else {
            preconditionFailure("Unable to construct unsplashURL")
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            preconditionFailure("Unable to construct unsplashTokenURL")
        }
                
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completionOnMainThread(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                completionOnMainThread(.failure(NetworkError.codeError))
                return
            }
            if let data {
                let decoder = JSONDecoder()

                do {
                    let authResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completionOnMainThread(.success(authResponse.accessToken))
                } catch {
                    completionOnMainThread(.failure(error))
                }
            } else {
                completionOnMainThread(.failure(AuthErrors.defaultError))
            }
        }
        task.resume()
    }
}
