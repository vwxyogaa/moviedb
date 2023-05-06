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
    func search(query: String?) -> Observable<TMDB>
    // MARK: - Locale
    func checkMovieInCollection(id: Int) -> Observable<Bool>
    func addToCollection(movie: Movie) -> Observable<Bool>
    func deleteFromCollection(id: Int) -> Observable<Bool>
    func getCollection() -> Observable<[Movie]>
}

final class Repository: NSObject {
    typealias MovieInstance = (RemoteDataSource, LocaleDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    fileprivate let locale: LocaleDataSource
    
    init(remote: RemoteDataSource, locale: LocaleDataSource) {
        self.remote = remote
        self.locale = locale
    }
    
    static let sharedInstance: MovieInstance = { remote, locale in
        return Repository(remote: remote, locale: locale)
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
    
    func search(query: String?) -> Observable<TMDB> {
        return remote.search(query: query)
    }
    
    // MARK: - Locale
    func checkMovieInCollection(id: Int) -> Observable<Bool> {
        return locale.checkMovieInCollection(id: id)
    }
    
    func addToCollection(movie: Movie) -> Observable<Bool> {
        return locale.addToCollection(movie: DataMapper.mapMovieModelToObj(data: movie))
    }
    
    func deleteFromCollection(id: Int) -> Observable<Bool> {
        return locale.deleteFromCollection(id: id)
    }
    
    func getCollection() -> Observable<[Movie]> {
        return locale.getCollection()
            .map { DataMapper.mapListObjMovieToListModel(array: $0) }
    }
}
