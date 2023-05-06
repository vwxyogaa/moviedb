//
//  MyMovieViewModel.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift
import RxCocoa

class MyMovieViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let myMovieUseCase: MyMovieUseCaseProtocol
    
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    
    init(myMovieUseCase: MyMovieUseCaseProtocol) {
        self.myMovieUseCase = myMovieUseCase
    }
    
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    var movieCount: Int {
        return _movies.value.count
    }
    
    func movie(at index: Int) -> Movie? {
        return _movies.value[safe: index]
    }
    
    func refresh() {
        getMyCollection()
    }
    
    func getMyCollection() {
        self._isLoading.accept(true)
        myMovieUseCase.getCollection()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._movies.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
