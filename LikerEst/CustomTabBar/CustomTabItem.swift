//
//  CustomTabItem.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import UIKit

enum CustomTabItem: String, CaseIterable {
    case home
    case favourites
}

extension CustomTabItem {
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeVC()
        case .favourites:
            return FavouritesVC()
        }
    }

    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .favourites:
            return UIImage(systemName: "heart.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .favourites:
            return UIImage(systemName: "heart.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
    }

    var name: String {
        return self.rawValue.capitalized
    }
}
