
import Foundation

 struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}

fileprivate enum ProfileErrors: Error {
    case badRequest
    case codeError
    case defaultError
    
}

final class ProfileService {
    private init() {}
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeRequest() else {
            completion(.failure(ProfileErrors.badRequest))
            return
        }
        
        if let task = self.task {
            task.cancel()
        }
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                completion(.failure(error))
                print("Error received requesting data")
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(ProfileErrors.codeError))
                print("Error received requesting data")
                return
            }
            
            if let data {
                let decoder = JSONDecoder()
                do {
                    let profileResponse = try decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(
                        username: profileResponse.username,
                        name: "\(profileResponse.firstName ?? "") \(profileResponse.lastName ?? "")",
                        loginName: "@\(profileResponse.username)",
                        bio: profileResponse.bio ?? "")
                    self.profile = profile
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                    print("Failed to parse: \(error.localizedDescription)")
                }
            } else {
                completion(.failure(ProfileErrors.defaultError))
                print("Аuthentication error")
                
            }
        }
        task.resume()
        self.task = task
    }
    
}

private func makeRequest() -> URLRequest? {
    guard let urlComponent = URLComponents(string: "https://api.unsplash.com/me") else {
        return nil
    }
    
    guard let url = urlComponent.url, let accessToken = OAuth2TokenStorage().token else {
        return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("BEARER \(accessToken)", forHTTPHeaderField: "Authorization")
    return request
    
}
