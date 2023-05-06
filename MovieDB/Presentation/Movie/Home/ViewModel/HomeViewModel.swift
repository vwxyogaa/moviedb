//
//  HomeViewModel.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let homeUseCase: HomeUseCaseProtocol
    
    private let _nowPlayings = BehaviorRelay<[TMDB.Results]?>(value: nil)
    
    // MARK: - Pagination
    // now playing
    private var nowPlayingResults = [TMDB.Results]()
    private var nowPlayingResultsCount = 0
    private var nowPlayingPage = 1
    private var nowPlayingCanLoadNextPage = false
    
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
        super.init()
        getNowPlaying()
    }
    
    func refresh() {
        nowPlayingResults = []
        nowPlayingResultsCount = 0
        nowPlayingPage = 1
        
        getNowPlaying()
    }
}

// MARK: - Now Playing
extension HomeViewModel {
    var nowPlayings: Driver<[TMDB.Results]?> {
        return _nowPlayings.asDriver()
    }
    
    var nowPlayingCount: Int {
        return _nowPlayings.value?.count ?? 0
    }
    
    func nowPlaying(at index: Int) -> TMDB.Results? {
        return _nowPlayings.value?[safe: index]
    }
    
    func getNowPlaying() {
        self._isLoading.accept(true)
        homeUseCase.getNowPlaying(page: nowPlayingPage)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.nowPlayingResults.append(contentsOf: result.results ?? [])
                self.nowPlayingResultsCount += result.results?.count ?? 0
                if self.nowPlayingResults.count == self.nowPlayingResultsCount {
                    self.nowPlayingPage += 1
                    self.nowPlayingCanLoadNextPage = false
                    self._nowPlayings.accept(self.nowPlayingResults)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func loadNowPlayingNextPage(index: Int) {
        if !nowPlayingCanLoadNextPage {
            if nowPlayingCount - 2 == index {
                nowPlayingCanLoadNextPage = true
                getNowPlaying()
            }
        }
    }
}
