//
//  SearchViewController.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    @IBOutlet weak var searchMovieTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.searchMovieTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.searchMovieTextField.resignFirstResponder()
    }
    
    // MARK: - Helpers
    private func configureViews() {
        configureSearchTextField()
        configureCancelButton()
        configureCollectionView()
    }
    
    private func initObserver() {
        viewModel.movies.drive(onNext: { [weak self] movie in
            if let movie = movie, !movie.isEmpty {
                self?.movieListCollectionView.clearBackground()
            } else {
                self?.movieListCollectionView.setBackground(imageName: "icon_empty_items", messageImage: "Not Found")
            }
            self?.movieListCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
    }
    
    private func configureSearchTextField() {
        searchMovieTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        searchMovieTextField.clearButtonMode = .whileEditing
        searchMovieTextField.delegate = self
        searchMovieTextField.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                let query = value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                self.viewModel.search(query: query)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureCancelButton() {
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        movieListCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        movieListCollectionView.dataSource = self
        movieListCollectionView.delegate = self
    }
    
    // MARK: - Action
    @objc
    private func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieListCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = viewModel.movie(at: indexPath.row)
        cell.configureContent(content: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
        detailViewController.viewModel = detailViewModel
        detailViewController.id = viewModel.movie(at: indexPath.row)?.id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = movieListCollectionView.frame.width / 3.2
        let height = movieListCollectionView.frame.height / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
