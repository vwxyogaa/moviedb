//
//  Injection.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

final class Injection {
    func provideHomeUseCase() -> HomeUseCaseProtocol {
        let repository = provideRepository()
        return HomeUseCase(repository: repository)
    }
    
    func provideDetailUseCase() -> DetailUseCaseProtocol {
        let repository = provideRepository()
        return DetailUseCase(repository: repository)
    }
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let remoteDataSource = RemoteDataSource()
        return Repository.sharedInstance(remoteDataSource)
    }
}
