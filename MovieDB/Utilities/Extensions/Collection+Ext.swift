//
//  Collection+Ext.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
