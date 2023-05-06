//
//  DetailUseCase.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift

protocol DetailUseCaseProtocol {
    // MARK: - Remote
    func getDetail(id: Int) -> Observable<Movie>
    func getReviews(id: Int) -> Observable<Reviews>
}

final class DetailUseCase: DetailUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Remote
    func getDetail(id: Int) -> Observable<Movie> {
        return self.repository.getDetail(id: id)
    }
    
    func getReviews(id: Int) -> Observable<Reviews> {
        return self.repository.getReviews(id: id)
    }
}
