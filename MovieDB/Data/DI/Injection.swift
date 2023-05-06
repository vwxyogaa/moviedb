//
//  Injection.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RealmSwift

final class Injection {
    func provideHomeUseCase() -> HomeUseCaseProtocol {
        let repository = provideRepository()
        return HomeUseCase(repository: repository)
    }
    
    func provideDetailUseCase() -> DetailUseCaseProtocol {
        let repository = provideRepository()
        return DetailUseCase(repository: repository)
    }
    
    func provideSearchUseCase() -> SearchUseCaseProtocol {
        let repository = provideRepository()
        return SearchUseCase(repository: repository)
    }
    
    func provideMyMovieUseCase() -> MyMovieUseCaseProtocol {
        let repository = provideRepository()
        return MyMovieUseCase(repository: repository)
    }
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let realm = try? Realm()
        let localeDataSource = LocaleDataSource.sharedInstance(realm)
        let remoteDataSource = RemoteDataSource()
        return Repository.sharedInstance(remoteDataSource, localeDataSource)
    }
}
