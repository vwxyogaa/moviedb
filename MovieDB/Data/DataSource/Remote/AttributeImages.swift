//
//  AttributeImages.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

extension TMDB.Results {
    var posterPathImage: String? {
        get {
            guard let posterPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.original + posterPath
        }
    }
}