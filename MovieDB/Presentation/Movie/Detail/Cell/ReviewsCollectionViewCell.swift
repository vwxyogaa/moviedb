//
//  ReviewsCollectionViewCell.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarPathImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.systemGray3.cgColor
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true
        
        self.avatarPathImageView.layer.cornerRadius = avatarPathImageView.frame.height / 2
        self.avatarPathImageView.layer.masksToBounds = true
    }
    
    func configureContent(review: Reviews.Result?) {
        if let avatarPathImage = review?.authorDetails?.avatarPathImage, !avatarPathImage.isEmpty {
            self.avatarPathImageView.loadImage(uri: avatarPathImage)
        } else {
            self.avatarPathImageView.backgroundColor = .black
        }
        self.authorLabel.text = "A Review by \(review?.author ?? "")"
        let createdAt = Utils.convertDateValidToDesc(review?.createdAt ?? "")
        self.createdAtLabel.text = "Written by \(review?.author ?? "") on \(createdAt)"
        self.contentLabel.text = review?.content
    }
}
