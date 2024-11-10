//
//  FavouritesVC.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import UIKit

final class FavouritesVC: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.configureWith("Favourites", color: .black, alignment: .center, size: 28)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        setupProperties()
    }
}

// MARK: - Base ViewController methods

extension FavouritesVC: BaseVCProtocol {
    func setupView() {
        view.addSubview(titleLabel)
    }

    func makeConstraints() {
        titleLabel.center(inView: view)
    }

    func setupProperties() {
        view.backgroundColor = #colorLiteral(red: 0.9517185092, green: 0.6961403489, blue: 0.6050165892, alpha: 1)
    }

    func bind() {
        print("Hello World!")
    }
}
