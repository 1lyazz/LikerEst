//
//  SavedPhotoCell.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 10.11.24.
//

import UIKit

final class SavedPhotoCell: UITableViewCell {
    private lazy var thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.configureImage()
        return imageView
    }()

    private lazy var authorName: UILabel = {
        let label = UILabel()
        label.configureWith(color: .label, alignment: .left, size: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with photo: Photo) {
        thumbnailImage.sd_setImage(with: URL(string: photo.urls.thumb), completed: nil)
        authorName.text = photo.user.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
        authorName.text = ""
    }
}

// MARK: - Private Methods

private extension SavedPhotoCell {
    private func setupView() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(authorName)
    }

    private func makeConstraints() {
        thumbnailImage.anchor(top: contentView.topAnchor,
                              left: contentView.leftAnchor,
                              bottom: contentView.bottomAnchor,
                              paddingTop: 8,
                              paddingLeft: 8,
                              paddingBottom: 8,
                              width: 150,
                              height: 150)

        authorName.anchor(left: thumbnailImage.rightAnchor,
                          right: contentView.rightAnchor,
                          paddingLeft: 12,
                          paddingRight: 8)

        authorName.centerY(inView: contentView)
    }
}
