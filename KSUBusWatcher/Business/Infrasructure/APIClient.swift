import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol APIRequest {
    associatedtype Response: Decodable
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
}

class APIClient: NSObject {
    static var baseURL = ""

    static func sendRequest<Request: APIRequest>(_ request: Request, handler: @escaping ((Result<Request.Response>) -> Void)) {
        Alamofire.request(APIClient.baseURL + request.path, parameters: request.parameters).responseJSON { result in
            print(result.request?.url)
            guard let data = result.data else {
                fatalError("TODO")
            }
            do {
                let response: Request.Response = try JSONDecoder().decode(Request.Response.self, from: data)
                handler(.success(response))
            } catch let error {
                handler(.failure(error))
            }
        }
    }
}
