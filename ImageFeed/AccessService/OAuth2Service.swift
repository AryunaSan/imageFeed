
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
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(NetworkError.defaultError))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(NetworkError.defaultError))
            return
        }
        
        URLSession.shared.objectTask(for: request) { (result: Result<AuthResponse, Error>) in
                   switch result {
                   case .success(let decodedResponse):
                       let accessToken = decodedResponse.accessToken
                       OAuth2TokenStorage().token = accessToken
                       DispatchQueue.main.async {
                           completion(.success(accessToken))
                       }
                   case .failure(let error):
                       DispatchQueue.main.async {
                           completion(.failure(error))
                           let decodingError = NetworkError.decodingError
                           print("[OAuth2Service.fetchOAuthToken]: \(decodingError)")
                       }
                   }
               }.resume()
           }
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
