//
//  LocaleDataSource.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import Foundation
import RxSwift
import RealmSwift

protocol LocaleDataSourceProtocol: AnyObject {
    func checkMovieInCollection(id: Int) -> Observable<Bool>
    func addToCollection(movie: ObjMovieModel) -> Observable<Bool>
    func deleteFromCollection(id: Int) -> Observable<Bool>
    func getCollection() -> Observable<Results<ObjMovieModel>>
}

final class LocaleDataSource: NSObject {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDB in
        return LocaleDataSource(realm: realmDB)
    }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
    func checkMovieInCollection(id: Int) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                let movieDB = realm.objects(ObjMovieModel.self)
                let movie = movieDB.first(where: { $0.id == id })
                movie == nil ? observer.onNext(false) : observer.onNext(true)
                observer.onCompleted()
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func addToCollection(movie: ObjMovieModel) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write({
                        movie.isSaved = true
                        realm.add(movie)
                        observer.onNext(true)
                        observer.onCompleted()
                    })
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func deleteFromCollection(id: Int) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    let movieDB = realm.objects(ObjMovieModel.self)
                    let movie = movieDB.first(where: { $0.id == id })
                    if movie == nil {
                        observer.onNext(true)
                        observer.onCompleted()
                    } else {
                        try realm.write({
                            realm.delete(movie!)
                            observer.onNext(true)
                            observer.onCompleted()
                        })
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func getCollection() -> Observable<Results<ObjMovieModel>> {
        return Observable<Results<ObjMovieModel>>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write({
                        observer.onNext(realm.objects(ObjMovieModel.self))
                        observer.onCompleted()
                    })
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
}

enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance: return "Database can't instance."
        case .requestFailed: return "Your request failed."
        }
    }
}
