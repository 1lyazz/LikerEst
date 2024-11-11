//
//  CustomTabBar.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class CustomTabBar: UIStackView {
    var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }
    
    private let homeItem = CustomItemView(with: .home, index: 0)
    private let favouritesItem = CustomItemView(with: .favourites, index: 1)
    
    private lazy var customItemViews: [CustomItemView] = [homeItem, favouritesItem]
    
    private let itemTappedSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupProperties()
        bind()
        
        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        addArrangedSubviews([homeItem, favouritesItem])
    }
    
    // MARK: - Setup Properties
    
    private func setupProperties() {
        distribution = .fillEqually
        alignment = .center
                
        setupCornerRadius(30)
        
        for customItemView in customItemViews {
            customItemView.translatesAutoresizingMaskIntoConstraints = false
            customItemView.clipsToBounds = true
        }
    }
    
    // MARK: - Bindings
    
    private func bind() {
        homeItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.homeItem.animateClick {
                    self.selectItem(index: self.homeItem.index)
                    
                    NotificationCenter.default.post(name: .homeTabTapped, object: nil)
                }
            }
            .disposed(by: disposeBag)
        
        favouritesItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.favouritesItem.animateClick {
                    self.selectItem(index: self.favouritesItem.index)
                    NotificationCenter.default.post(name: .favouritesTabTapped, object: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        itemTappedSubject.onNext(index)
    }
}

extension Notification.Name {
    static let homeTabTapped = Notification.Name("homeTabTapped")
    static let favouritesTabTapped = Notification.Name("favouritesTabTapped")
}
