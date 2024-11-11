

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImageURL
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImageURL: Codable {
    let small: String
}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private init() {}
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeRequest(username: username) else {
            completion(.failure(NetworkError.badRequest))
            return
        }
        
        if let task = self.task {
            task.cancel()
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case.success(let userResult):
                self.avatarURL = userResult.profileImage.small
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": userResult.profileImage.small]
                    )
                completion(.success(userResult.profileImage.small))
            case .failure(let error):
                let invalidSessionError = NetworkError.urlSessionError
                print("[objectTask]: fetchProfileImageURL - \(invalidSessionError)")
                completion(.failure(error))
            }
            self.task?.resume()
        }
    }
    
    func makeRequest(username: String) -> URLRequest? {
        guard let urlComponent = URLComponents(string: Constants.defaultBaseURLString + "/users/\(username)") else {
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
