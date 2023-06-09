//
//  HomeViewController.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var nowPlayingCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionViewHeight: NSLayoutConstraint!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserver()
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
        configureScrollView()
        configureCollectionViews()
    }
    
    private func initObserver() {
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
        
        viewModel.nowPlayings.drive(onNext: { [weak self] _ in
            self?.nowPlayingCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.populars.drive(onNext: { [weak self] _ in
            self?.popularCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.upcomings.drive(onNext: { [weak self] _ in
            self?.upcomingCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MovieDB"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchButtonTapped))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func configureScrollView() {
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
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
    
    private func goToSearchPage() {
        let searchViewController = SearchViewController()
        let searchViewModel = SearchViewModel(searchUseCase: Injection().provideSearchUseCase())
        searchViewController.viewModel = searchViewModel
        searchViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    // MARK: - Actions
    @objc
    private func searchButtonTapped() {
        goToSearchPage()
    }
    
    @objc
    private func refreshData() {
        self.refreshControl.endRefreshing()
        self.viewModel.refresh()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case nowPlayingCollectionView:
            return viewModel.nowPlayingCount
        case popularCollectionView:
            return viewModel.popularCount
        case upcomingCollectionView:
            return viewModel.upcomingCount
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case nowPlayingCollectionView:
            guard let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let nowPlaying = viewModel.nowPlaying(at: indexPath.row)
            cell.configureContent(content: nowPlaying)
            viewModel.loadNowPlayingNextPage(index: indexPath.row)
            return cell
        case popularCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let popular = viewModel.popular(at: indexPath.row)
            cell.configureContent(content: popular)
            viewModel.loadPopularNextPage(index: indexPath.row)
            return cell
        case upcomingCollectionView:
            guard let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let upcoming = viewModel.upcoming(at: indexPath.row)
            cell.configureContent(content: upcoming)
            viewModel.loadMovieNextPage(index: indexPath.row)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case nowPlayingCollectionView:
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.nowPlaying(at: indexPath.row)?.id
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        case popularCollectionView:
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.popular(at: indexPath.row)?.id
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        case upcomingCollectionView:
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.upcoming(at: indexPath.row)?.id
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        default:
            break
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
