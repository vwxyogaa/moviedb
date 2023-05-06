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
}
