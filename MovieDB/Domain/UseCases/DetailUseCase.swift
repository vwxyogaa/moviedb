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
    // MARK: - Locale
    func checkMovieInCollection(id: Int) -> Observable<Bool>
    func addToCollection(movie: Movie) -> Observable<Bool>
    func deleteFromCollection(id: Int) -> Observable<Bool>
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
    
    // MARK: - Locale
    func checkMovieInCollection(id: Int) -> Observable<Bool> {
        return repository.checkMovieInCollection(id: id)
    }
    
    func addToCollection(movie: Movie) -> Observable<Bool> {
        return repository.addToCollection(movie: movie)
    }
    
    func deleteFromCollection(id: Int) -> Observable<Bool> {
        return repository.deleteFromCollection(id: id)
    }
}
