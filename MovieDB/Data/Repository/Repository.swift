//
//  Repository.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    // MARK: - Remote
    func getNowPlaying(page: Int) -> Observable<TMDB>
    func getPopular(page: Int) -> Observable<TMDB>
    func getUpcoming(page: Int) -> Observable<TMDB>
    func getDetail(id: Int) -> Observable<Movie>
    func getReviews(id: Int) -> Observable<Reviews>
}

final class Repository: NSObject {
    typealias MovieInstance = (RemoteDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    
    init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: MovieInstance = { remote in
        return Repository(remote: remote)
    }
}

extension Repository: RepositoryProtocol {
    // MARK: - Remote
    func getNowPlaying(page: Int) -> Observable<TMDB> {
        return remote.getNowPlaying(page: page)
    }
    
    func getPopular(page: Int) -> Observable<TMDB> {
        return remote.getPopular(page: page)
    }
    
    func getUpcoming(page: Int) -> Observable<TMDB> {
        return remote.getUpcoming(page: page)
    }
    
    func getDetail(id: Int) -> Observable<Movie> {
        return remote.getDetail(id: id)
    }
    
    func getReviews(id: Int) -> Observable<Reviews> {
        return remote.getReviews(id: id)
    }
}
