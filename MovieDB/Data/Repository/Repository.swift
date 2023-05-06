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
}
