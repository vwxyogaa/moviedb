//
//  TabBarViewController.swift
//  MovieDB
//
//  Created by yxgg on 06/05/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makeTabBar() -> TabBarViewController {
        self.viewControllers = [
            makeNavigation(viewController: createHomeTab()),
            makeNavigation(viewController: createMyMovieTab())
        ]
        return self
    }
    
    private func makeNavigation(viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.delegate = self
        navigation.navigationBar.prefersLargeTitles = false
        return navigation
    }
    
    private func createHomeTab() -> UIViewController {
        let homeController = HomeViewController()
        homeController.tabBarItem.title = "Home"
        homeController.tabBarItem.image = UIImage(systemName: "house")
        homeController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        let homeViewModel = HomeViewModel(homeUseCase: Injection().provideHomeUseCase())
        homeController.viewModel = homeViewModel
        return homeController
    }
    
    private func createMyMovieTab() -> UIViewController {
        let myMovieController = MyMovieViewController()
        myMovieController.tabBarItem.title = "My Movie"
        myMovieController.tabBarItem.image = UIImage(systemName: "bookmark")
        myMovieController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        let myMovieViewModel = MyMovieViewModel(myMovieUseCase: Injection().provideMyMovieUseCase())
        myMovieController.viewModel = myMovieViewModel
        return myMovieController
    }
}

// MARK: - UINavigationControllerDelegate
extension UIViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 14.0, *) {
            viewController.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
            viewController.navigationItem.backButtonTitle = ""
        }
        viewController.navigationController?.navigationBar.tintColor = .black
    }
}
