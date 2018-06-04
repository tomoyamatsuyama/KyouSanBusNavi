import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: APIClient {
    static func respose<Request: APIRequest>(to request: Request) -> Observable<Request.Response> {
        
        return .create({(observer: AnyObserver<Request.Response>) in
            APIClient.sendRequest(request) { result in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        })
    }
}
