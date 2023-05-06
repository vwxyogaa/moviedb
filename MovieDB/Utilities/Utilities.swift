//
//  Utilities.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import RealmSwift

final class DataMapper {
    static func mapMovieModelToObj(data: Movie) -> ObjMovieModel {
        let result = ObjMovieModel()
        result.id = data.id ?? 0
        result.posterPath = data.posterPath ?? ""
        result.title = data.title ?? ""
        return result
    }
    
    static func mapListObjMovieToListModel(array: Results<ObjMovieModel>) -> [Movie] {
        return array.map {
            mapObjMovieToModel(data: $0)
        }
    }
    
    static func mapObjMovieToModel(data: ObjMovieModel) -> Movie {
        return Movie(adult: nil, backdropPath: nil, belongsToCollection: nil, budget: nil, genres: nil, homepage: nil, id: data.id, imdbID: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: data.posterPath, productionCompanies: nil, productionCountries: nil, releaseDate: nil, revenue: nil, runtime: nil, spokenLanguages: nil, status: nil, tagline: nil, title: data.title, video: nil, voteAverage: nil, voteCount: nil)
    }
}
