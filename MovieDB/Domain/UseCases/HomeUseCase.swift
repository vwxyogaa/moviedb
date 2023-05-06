//
//  HomeUseCase.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift

protocol HomeUseCaseProtocol {
    func getNowPlaying(page: Int) -> Observable<TMDB>
    func getPopular(page: Int) -> Observable<TMDB>
    func getUpcoming(page: Int) -> Observable<TMDB>
}

final class HomeUseCase: HomeUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getNowPlaying(page: Int) -> Observable<TMDB> {
        return self.repository.getNowPlaying(page: page)
    }
    
    func getPopular(page: Int) -> Observable<TMDB> {
        return self.repository.getPopular(page: page)
    }
    
    func getUpcoming(page: Int) -> Observable<TMDB> {
        return self.repository.getUpcoming(page: page)
    }
}
