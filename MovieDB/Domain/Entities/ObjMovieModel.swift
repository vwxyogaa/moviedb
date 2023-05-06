//
//  ObjMovieModel.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import Foundation
import RealmSwift

class ObjMovieModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var posterPath: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var isSaved: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
