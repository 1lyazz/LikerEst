//
//  PhotoCell.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(imageView)
    }

    private func makeConstraints() {
        imageView.fillSuperView()
    }

    func configure(with url: URL?) {
        guard let url = url else {
            imageView.image = UIImage(named: "errPhoto")
            return
        }

        imageView.sd_setImage(with: url, placeholderImage: .placeholder) { [weak self] _, error, _, _ in
            if error != nil { self?.imageView.image = UIImage(named: "errPhoto") }
        }
    }
}