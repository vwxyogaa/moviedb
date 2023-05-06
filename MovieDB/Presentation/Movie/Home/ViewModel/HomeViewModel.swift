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
    private let _populars = BehaviorRelay<[TMDB.Results]?>(value: nil)
    private let _upcomings = BehaviorRelay<[TMDB.Results]?>(value: nil)
    
    // MARK: - Pagination
    // now playing
    private var nowPlayingResults = [TMDB.Results]()
    private var nowPlayingResultsCount = 0
    private var nowPlayingPage = 1
    private var nowPlayingCanLoadNextPage = false
    
    // popular
    private var popularResults = [TMDB.Results]()
    private var popularResultsCount = 0
    private var popularPage = 1
    private var popularCanLoadNextPage = false
    
    private var upcomingResults = [TMDB.Results]()
    private var upcomingResultsCount = 0
    private var upcomingPage = 1
    private var upcomingCanLoadNextPage = false
    
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
        super.init()
        getNowPlaying()
        getPopular()
        getUpcoming()
    }
    
    func refresh() {
        nowPlayingResults = []
        nowPlayingResultsCount = 0
        nowPlayingPage = 1
        
        popularResults = []
        popularResultsCount = 0
        popularPage = 1
        
        upcomingResults = []
        upcomingResultsCount = 0
        upcomingPage = 1
        
        getNowPlaying()
        getPopular()
        getUpcoming()
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

// MARK: - Popular
extension HomeViewModel {
    var populars: Driver<[TMDB.Results]?> {
        return _populars.asDriver()
    }
    
    var popularCount: Int {
        return _populars.value?.count ?? 0
    }
    
    func popular(at index: Int) -> TMDB.Results? {
        return _populars.value?[safe: index]
    }
    
    func getPopular() {
        self._isLoading.accept(true)
        homeUseCase.getPopular(page: popularPage)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.popularResults.append(contentsOf: result.results ?? [])
                self.popularResultsCount += result.results?.count ?? 0
                if self.popularResults.count == self.popularResultsCount {
                    self.popularPage += 1
                    self.popularCanLoadNextPage = false
                    self._populars.accept(self.popularResults)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func loadPopularNextPage(index: Int) {
        if !popularCanLoadNextPage {
            if popularCount - 2 == index {
                popularCanLoadNextPage = true
                getPopular()
            }
        }
    }
}

// MARK: - Upcoming
extension HomeViewModel {
    var upcomings: Driver<[TMDB.Results]?> {
        return _upcomings.asDriver()
    }
    
    var upcomingCount: Int {
        return _upcomings.value?.count ?? 0
    }
    
    func upcoming(at index: Int) -> TMDB.Results? {
        return _upcomings.value?[safe: index]
    }
    
    func getUpcoming() {
        self._isLoading.accept(true)
        homeUseCase.getUpcoming(page: upcomingPage)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.upcomingResults.append(contentsOf: result.results ?? [])
                self.upcomingResultsCount += result.results?.count ?? 0
                if self.upcomingResults.count == self.upcomingResultsCount {
                    self.upcomingPage += 1
                    self.upcomingCanLoadNextPage = false
                    self._upcomings.accept(self.upcomingResults)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func loadMovieNextPage(index: Int) {
        if !upcomingCanLoadNextPage {
            if upcomingCount - 2 == index {
                upcomingCanLoadNextPage = true
                getUpcoming()
            }
        }
    }
}
