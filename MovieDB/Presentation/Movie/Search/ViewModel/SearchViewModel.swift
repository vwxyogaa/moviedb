//
//  SearchViewModel.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift
import RxCocoa

class SearchViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let searchUseCase: SearchUseCaseProtocol
    
    private let _movies = BehaviorRelay<[TMDB.Results]?>(value: nil)
    
    init(searchUseCase: SearchUseCaseProtocol) {
        self.searchUseCase = searchUseCase
        super.init()
    }
    
    var movies: Driver<[TMDB.Results]?> {
        return _movies.asDriver()
    }
    
    var movieCount: Int {
        return _movies.value?.count ?? 0
    }
    
    func movie(at index: Int) -> TMDB.Results? {
        return _movies.value?[safe: index]
    }
    
    func search(query: String?) {
        self._isLoading.accept(true)
        searchUseCase.search(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._movies.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
