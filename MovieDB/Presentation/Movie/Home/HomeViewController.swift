//
//  HomeViewController.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var nowPlayingCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionViewHeight: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nowPlayingCollectionViewHeight.constant = nowPlayingCollectionView.frame.height
        popularCollectionViewHeight.constant = popularCollectionView.frame.height
        upcomingCollectionViewHeight.constant = upcomingCollectionView.frame.height
    }
    
    // MARK: - Helpers
    private func configureViews() {
        configureNavBar()
        configureCollectionViews()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MovieDB"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchButtonTapped))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func configureCollectionViews() {
        nowPlayingCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        
        popularCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        
        upcomingCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.delegate = self
    }
    
    // MARK: - Actions
    @objc
    private func searchButtonTapped() {
        print("search button tapped")
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case nowPlayingCollectionView:
            return 5
        case popularCollectionView:
            return 5
        case upcomingCollectionView:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case nowPlayingCollectionView:
            guard let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case popularCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case upcomingCollectionView:
            guard let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case nowPlayingCollectionView:
            let width = view.frame.width / 3
            let height = nowPlayingCollectionView.frame.height
            return CGSize(width: width, height: height)
        case popularCollectionView:
            let width = view.frame.width / 3
            let height = popularCollectionView.frame.height
            return CGSize(width: width, height: height)
        case upcomingCollectionView:
            let width = view.frame.width / 3
            let height = upcomingCollectionView.frame.height
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case nowPlayingCollectionView:
            return 8
        case popularCollectionView:
            return 8
        case upcomingCollectionView:
            return 8
        default:
            return 0
        }
    }
}
