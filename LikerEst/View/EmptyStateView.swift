//
//  EmptyStateView.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 11.11.24.
//

import UIKit

final class EmptyStateView: UIView {
    // MARK: - UI Elements

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    init(image: UIImage?, message: String) {
        super.init(frame: .zero)
        imageView.image = image
        messageLabel.text = message
        setupView()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

// MARK: - Private Methods

private extension EmptyStateView {
    private func setupView() {
        addSubviews(imageView, messageLabel)
    }

    private func makeConstraints() {
        imageView.anchor(width: 300, height: 130.78)

        imageView.centerX(inView: self)
        imageView.centerY(inView: self)

        messageLabel.anchor(top: imageView.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 16,
                            paddingLeft: 16,
                            paddingRight: 16)
    }
}
