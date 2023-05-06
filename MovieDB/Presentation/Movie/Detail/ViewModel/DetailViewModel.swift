//
//  DetailViewModel.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift
import RxCocoa

class DetailViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let detailUseCase: DetailUseCaseProtocol
    
    private let _movie = BehaviorRelay<Movie?>(value: nil)
    private let _reviews = BehaviorRelay<[Reviews.Result]?>(value: nil)
    private let _isSaved = BehaviorRelay<Bool>(value: false)
    
    init(detailUseCase: DetailUseCaseProtocol) {
        self.detailUseCase = detailUseCase
        super.init()
    }
}

extension DetailViewModel {
    // MARK: - Detail
    var movie: Driver<Movie?> {
        return _movie.asDriver()
    }
    
    func getDetail(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._movie.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - Reviews
    var reviews: Driver<[Reviews.Result]?> {
        return _reviews.asDriver()
    }
    
    var reviewCount: Int {
        return _reviews.value?.count ?? 0
    }
    
    func review(at index: Int) -> Reviews.Result? {
        return _reviews.value?[safe: index]
    }
    
    func getReviews(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getReviews(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._reviews.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - isSaved
    var isSaved: Driver<Bool> {
        return _isSaved.asDriver()
    }
    
    func checkMovieInCollection(id: Int?) {
        self._isLoading.accept(true)
        guard let id else { return }
        detailUseCase.checkMovieInCollection(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isSaved.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func addToCollection() {
        self._isLoading.accept(true)
        guard let movie = _movie.value else { return }
        detailUseCase.addToCollection(movie: movie)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isSaved.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func deleteFromCollection() {
        self._isLoading.accept(true)
        guard let id = _movie.value?.id else { return }
        detailUseCase.deleteFromCollection(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isSaved.accept(!result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
