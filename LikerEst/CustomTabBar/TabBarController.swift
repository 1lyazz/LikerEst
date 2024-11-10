//
//  TabBarController.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import RxSwift
import UIKit

final class TabBarController: UITabBarController {
    private lazy var customTabBar: CustomTabBar = {
        let tabBar = CustomTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = .black
        tabBar.alpha = 0.8
        tabBar.addShadow()
        return tabBar
    }()
    
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        setupProperties()
        bind()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        view.addSubview(customTabBar)
    }
    
    // MARK: - Constraints
        
    private func makeConstraints() {
        customTabBar.anchor(
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingLeft: 24,
            paddingBottom: 24,
            paddingRight: 24,
            height: 80
        )
    }
    
    // MARK: - Setup Properties
    
    private func setupProperties() {
        tabBar.isHidden = true
        selectedIndex = 0
        let controllers = CustomTabItem.allCases.map { $0.viewController }
        setViewControllers(controllers, animated: true)
        setupTabBarAppearance()
    }
    
    // MARK: - Bindings
    
    private func bind() {
        customTabBar.itemTapped
            .bind { [weak self] in self?.selectTabWith(index: $0) }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    private func selectTabWith(index: Int) {
        selectedIndex = index
    }
    
    private func setupTabBarAppearance() {
        guard #available(iOS 13.0, *) else { return }
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
