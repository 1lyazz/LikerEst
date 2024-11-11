//
//  PhotoDetailsVC.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import SDWebImage
import UIKit

final class PhotoDetailsVC: UIViewController {
    private let photo: Photo
    private var isImageLoaded: Bool = false
    weak var delegate: PhotoDetailsVCDelegate?

    // MARK: - UI Elements

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.configureWith(formatDate(photo.createdAt), color: .label, alignment: .left, size: 24, weight: .bold)
        return label
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.configureWith(photo.user.name, color: .systemGray, alignment: .left, size: 20)
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.configureWith(formatLocation(photo.location), color: .systemGray, alignment: .left, size: 16)
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemGray
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [heartButton, infoButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        stackView.tintColor = .label
        stackView.backgroundColor = .systemGray3
        stackView.setupCornerRadius(22)
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    // MARK: - Initialization

    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        setupProperties()
        bind()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.photoDetailsVCDidDismiss()
    }
}

// MARK: - BaseVCProtocol

extension PhotoDetailsVC: BaseVCProtocol {
    func setupView() {
        view.addSubviews(imageView, dateLabel, userNameLabel, locationLabel, stackView, closeButton, activityIndicator)
    }

    func makeConstraints() {
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingTop: 20,
                           paddingRight: 20)

        dateLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 20,
                         paddingRight: 50)

        userNameLabel.anchor(top: dateLabel.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 4,
                             paddingLeft: 20,
                             paddingRight: 10)

        locationLabel.anchor(top: userNameLabel.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingLeft: 20,
                             paddingRight: 10)

        imageView.anchor(top: locationLabel.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: stackView.topAnchor,
                         right: view.rightAnchor,
                         paddingTop: 10,
                         paddingBottom: 10)

        stackView.anchor(bottom: view.bottomAnchor,
                         paddingBottom: 34,
                         height: 45)
        stackView.centerX(inView: view)

        activityIndicator.center(inView: view)
    }

    func setupProperties() {
        view.backgroundColor = .systemBackground
        dateLabel.isHidden = dateLabel.text == nil
        userNameLabel.isHidden = userNameLabel.text == nil
        locationLabel.isHidden = locationLabel.text == nil

        if !isImageLoaded {
            activityIndicator.startAnimating()
            loadImage()
        }

        updateHeartButtonState()
    }

    private func bind() {
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)

        heartButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            toggleHeart()
        }), for: .touchUpInside)

        infoButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController.createDetailsAlert(photo: self.photo)
            self.present(alert, animated: true, completion: nil)
        }), for: .touchUpInside)
    }
}

// MARK: - Private Methods

private extension PhotoDetailsVC {
    // Asynс loads the image for the photo
    private func loadImage() {
        Task {
            await loadImageAsync()
        }
    }

    // Asynс fetches image data and updates the imageView
    private func loadImageAsync() async {
        guard let url = URL(string: photo.urls.full) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                // Update UI on the main thread
                await MainActor.run {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                    self.isImageLoaded = true
                }
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }

    // Formats a date string into a more readable format
    private func formatDate(_ dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        guard let date = inputFormatter.date(from: dateString) else { return nil }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short

        return outputFormatter.string(from: date)
    }

    // Formats a location into a readable string
    private func formatLocation(_ location: Location?) -> String? {
        guard let location = location else { return nil }
        switch (location.city, location.country) {
        case let (city?, country?):
            return "\(city), \(country)"
        case let (city?, nil):
            return city
        case let (nil, country?):
            return country
        default:
            return nil
        }
    }

    // Method of updating the heart indicator
    private func toggleHeart() {
        let isLiked = heartButton.tintColor == .red
        heartButton.setImage(UIImage(systemName: isLiked ? "heart" : "heart.fill"), for: .normal)
        heartButton.tintColor = isLiked ? .label : .red

        if isLiked {
            PhotoCoreDataService.shared.removePhoto(photo)
        } else {
            PhotoCoreDataService.shared.savePhoto(photo)
        }
    }

    // Update heart state button by checking isPhotoLiked
    private func updateHeartButtonState() {
        if PhotoCoreDataService.shared.isPhotoLiked(photo) {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartButton.tintColor = .red
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            heartButton.tintColor = .label
        }
    }
}
