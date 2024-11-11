
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
    let bio: String?
    
    init(username: String, name: String, loginName: String, bio: String?) {
                self.username = username
                self.name = name
                self.loginName = loginName
                self.bio = bio
            }
}

final class ProfileService {
    
    static let shared = ProfileService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeRequest(token: token) else {
            completion(.failure(NetworkError.badRequest))
            return
        }
        
        if let task = self.task {
            task.cancel()
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case.success(let profileResult):
                let profile = Profile(
                    username: profileResult.username,
                    name: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")",
                    loginName: "@\(profileResult.username)",
                    bio: profileResult.bio ?? "")
                self.profile = profile
                completion(.success(profile))
            case.failure(_):
                let URLSessionError = NetworkError.urlSessionError
                print("[objectTask]: Profile Service Error - \(URLSessionError)")
                completion(.failure(URLSessionError))
            }
        }
        task.resume()
        self.task = task
    }
    
    private func makeRequest(token: String) -> URLRequest? {
        guard let urlComponent = URLComponents(string: Constants.defaultBaseURLString + "/me") else {
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
}
