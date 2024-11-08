//
//  HomeVC.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import UIKit

final class HomeVC: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.configureWith("Home", color: .white, alignment: .center, size: 28)
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

extension HomeVC: BaseVCProtocol {
    func setupView() {
        view.addSubview(titleLabel)
    }

    func makeConstraints() {
        titleLabel.center(inView: view)
    }

    func setupProperties() {
        view.backgroundColor = #colorLiteral(red: 0.9452534318, green: 0.7393080592, blue: 0.6334522963, alpha: 1)
    }
}
