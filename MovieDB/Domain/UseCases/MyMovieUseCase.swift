//
//  MyMovieUseCase.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift

protocol MyMovieUseCaseProtocol {
    func getCollection() -> Observable<[Movie]>
}

class MyMovieUseCase: MyMovieUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getCollection() -> Observable<[Movie]> {
        return repository.getCollection()
    }
}
