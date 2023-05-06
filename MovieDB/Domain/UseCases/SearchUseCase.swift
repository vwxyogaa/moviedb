//
//  SearchUseCase.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift

protocol SearchUseCaseProtocol {
    func search(query: String?) -> Observable<TMDB>
}

final class SearchUseCase: SearchUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func search(query: String?) -> Observable<TMDB> {
        return self.repository.search(query: query)
    }
}
