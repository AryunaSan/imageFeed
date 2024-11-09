

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    let decodingError = NetworkError.decodingError
                    print("[objectTask]: Network Error - \(decodingError)")
                    completion(.failure(decodingError))
                }
            case .failure(_):
                let urlSessionError = NetworkError.urlSessionError
                print("[objectTask]: Network Error - \(urlSessionError)")
                completion(.failure(urlSessionError))
            }
        }
        return task
    }
}
