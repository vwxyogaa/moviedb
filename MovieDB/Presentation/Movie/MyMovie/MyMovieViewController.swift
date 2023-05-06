//
//  MyMovieViewController.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit
import RxSwift

class MyMovieViewController: UIViewController {
    @IBOutlet weak var myMovieCollectionView: UICollectionView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: MyMovieViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        initObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getMyCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Helpers
    private func configureCollectionView() {
        myMovieCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        myMovieCollectionView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        myMovieCollectionView.dataSource = self
        myMovieCollectionView.delegate = self
    }
    
    private func initObserver() {
        viewModel.movies.drive(onNext: { [weak self] movie in
            if !movie.isEmpty {
                self?.myMovieCollectionView.clearBackground()
            } else {
                self?.myMovieCollectionView.setBackground(imageName: "icon_empty_items", messageImage: "You don't have favorite movie yet")
            }
            self?.myMovieCollectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
    }
    
    private func alertNoConnection() {
        let dialogMessage = UIAlertController(title: "", message: "No Internet Connection.\nPlease use internet connection!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc
    private func refreshData() {
        viewModel.refresh()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MyMovieViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myMovieCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = viewModel.movie(at: indexPath.row)
        cell.configureContentMyMovie(content: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.movie(at: indexPath.row)?.id
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            print("Internet Connection not Available!")
            self.alertNoConnection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = myMovieCollectionView.frame.width / 3.2
        let height = myMovieCollectionView.frame.height / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
