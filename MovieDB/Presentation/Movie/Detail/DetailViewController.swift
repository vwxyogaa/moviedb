//
//  DetailViewController.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var reviewsCollectionViewHeight: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    var viewModel: DetailViewModel!
    var id: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserver()
        configureData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reviewsCollectionViewHeight.constant = reviewsCollectionView.frame.height
    }
    
    // MARK: - Helpers
    private func configureViews() {
        self.navigationItem.largeTitleDisplayMode = .never
        configureButton()
        configureCollectionView()
    }
    
    private func initObserver() {
        viewModel.movie.drive(onNext: { [weak self] movie in
            self?.configureContent(movie: movie)
        }).disposed(by: disposeBag)
        
        viewModel.reviews.drive(onNext: { [weak self] review in
            if let review = review, !review.isEmpty {
                self?.reviewsStackView.isHidden = false
            } else {
                self?.reviewsStackView.isHidden = true
            }
            self?.reviewsCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
        
    }
    
    private func configureData() {
        if let id = id {
            viewModel.getDetail(id: id)
            viewModel.getReviews(id: id)
        }
    }
    
    private func configureButton() {
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.layer.masksToBounds = true
        saveButton.setTitle("", for: .normal)
        saveButton.tintColor = .black
        saveButton.addTarget(self, action: #selector(self.saveButtonTapped), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        self.reviewsCollectionView.register(UINib(nibName: "ReviewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewsCollectionViewCell")
        self.reviewsCollectionView.dataSource = self
        self.reviewsCollectionView.delegate = self
    }
    
    private func configureContent(movie: Movie?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(movie?.backdropPath ?? "")"
        if movie?.backdropPath == nil {
            self.backdropImageView.backgroundColor = .black
        } else {
            self.backdropImageView.loadImage(uri: imageUrl)
        }
        let year = Utils.convertDateToYearOnly(movie?.releaseDate ?? "-")
        self.titleLabel.text = "\(movie?.title ?? "") (\(year))"
        let voteAverageDecimal = movie?.voteAverage ?? 0
        let voteAverage = (String(format: "%.1f", voteAverageDecimal))
        let releaseDate = Utils.convertDateSimple(movie?.releaseDate ?? "-")
        let runtime = Utils.minutesToHoursAndMinutes(movie?.runtime ?? 0)
        self.categoriesLabel.text = "\(releaseDate) • ⭐️\(voteAverage) • \(runtime.hours)h \(runtime.leftMinutes)m"
        self.genresLabel.text = movie?.genres?.compactMap({$0.name}).joined(separator: ", ")
        if let tagline = movie?.tagline, !tagline.isEmpty {
            self.taglineLabel.text = "#\(tagline)".uppercased()
        } else {
            self.taglineLabel.text = "-"
        }
        self.overviewLabel.text = movie?.overview
    }
    
    // MARK: - Action
    @objc
    private func saveButtonTapped(_ sender: UIButton) {
        print("save button tapped")
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviewCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = reviewsCollectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionViewCell", for: indexPath) as? ReviewsCollectionViewCell else { return UICollectionViewCell() }
        let review = viewModel.review(at: indexPath.row)
        cell.configureContent(review: review)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = reviewsCollectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
