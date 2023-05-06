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
    
    init(detailUseCase: DetailUseCaseProtocol) {
        self.detailUseCase = detailUseCase
        super.init()
    }
}

// MARK: - Detail
extension DetailViewModel {
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

// MARK: - Reviews
extension DetailViewModel {
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
