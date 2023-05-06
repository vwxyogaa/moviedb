//
//  CardMovieCollectionViewCell.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit

class CardMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterPathImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
    }
    
    func configureContent(content: TMDB.Results?) {
        self.posterPathImageView.loadImage(uri: content?.posterPathImage)
    }
    
    func configureContentMyMovie(content: Movie?) {
        self.posterPathImageView.loadImage(uri: content?.posterPathImage)
    }
}
