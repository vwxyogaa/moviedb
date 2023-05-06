//
//  RemoteDataSource.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import Foundation
import RxSwift

final class RemoteDataSource {
    private let urlMovie = Constants.baseMovieUrl + Constants.moviePath
    
    func getNowPlaying(page: Int) -> Observable<TMDB> {
        let url = URL(string: urlMovie + "/now_playing?page=\(page)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getPopular(page: Int) -> Observable<TMDB> {
        let url = URL(string: urlMovie + "/popular?page=\(page)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getUpcoming(page: Int) -> Observable<TMDB> {
        let url = URL(string: urlMovie + "/upcoming?page=\(page)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getDetail(id: Int) -> Observable<Movie> {
        let url = URL(string: urlMovie + "/\(id)")!
        let data: Observable<Movie> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getReviews(id: Int) -> Observable<Reviews> {
        let url = URL(string: urlMovie + "/\(id)/reviews")!
        let data: Observable<Reviews> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
}
