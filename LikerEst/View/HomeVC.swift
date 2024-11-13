//
//  HomeVC.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import RxSwift
import Toast
import UIKit

final class HomeVC: UIViewController {
    private var photos: [Photo] = []
    private let disposeBag = DisposeBag()
    private let unsplashService = UnsplashService()
    private lazy var refreshControl = UIRefreshControl()

    private var currentPage = 1
    private var isFetchingPhotos = false
    private var currentSearchQuery: String?

    // MARK: - UI Elements

    private lazy var photoCollection: UICollectionView = {
        let layout = collectionLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.refreshControl = refreshControl
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return collection
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Photo search"
        searchBar.tintColor = .systemYellow
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var homeTitle: UILabel = {
        let label = UILabel()
        label.configureWith("Home", color: .label, alignment: .center, size: 34, weight: .bold)
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        setupProperties()
        bind()
    }
}

// MARK: - BaseVCProtocol

extension HomeVC: BaseVCProtocol {
    func setupView() {
        view.addSubviews(homeTitle, searchBar, photoCollection)
    }

    func makeConstraints() {
        searchBar.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 100,
                         paddingLeft: 16,
                         paddingRight: 16,
                         height: 44)

        photoCollection.anchor(top: searchBar.bottomAnchor,
                               left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor,
                               paddingTop: 8)
    }

    func setupProperties() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = homeTitle

        fetchRandomPhotos()
        setupGestureRecognizers()
    }

    private func bind() {
        refreshControl.addAction(UIAction { [weak self] _ in
            self?.refreshPhotos()
        }, for: .valueChanged)

        NotificationCenter.default.rx.notification(.homeTabTapped)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.scrollToTopIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private Methods

private extension HomeVC {
    // Refreshes photos after fetching a new set of random photos
    private func refreshPhotos() {
        guard !isFetchingPhotos else { return }
        isFetchingPhotos = true

        guard Reachability.isConnectedToNetwork() else {
            isFetchingPhotos = false
            view.makeToast("No internet connection", duration: 3.0, position: .center)
            refreshControl.endRefreshing()
            return
        }

        unsplashService.fetchRandomPhotos { [weak self] photos in
            DispatchQueue.main.async {
                self?.isFetchingPhotos = false
                guard let self = self, let photos = photos else {
                    self?.refreshControl.endRefreshing()
                    return
                }
                self.photos = photos
                self.photoCollection.reloadData()
                self.searchBar.text = ""
                self.refreshControl.endRefreshing()
                self.currentSearchQuery = nil
                self.currentPage = 1
            }
        }
    }

    // Gets random photos and adds them to the photo array
    private func fetchRandomPhotos() {
        guard !isFetchingPhotos else { return }
        isFetchingPhotos = true

        guard Reachability.isConnectedToNetwork() else {
            isFetchingPhotos = false
            view.makeToast("No internet connection", duration: 3.0, position: .center)
            return
        }

        unsplashService.fetchRandomPhotos { [weak self] photos in
            DispatchQueue.main.async {
                self?.isFetchingPhotos = false
                guard let self = self, let photos = photos else { return }
                self.photos.append(contentsOf: photos)
                self.photoCollection.reloadData()
            }
        }
    }

    // Scrolls collection view to top (if it's not there)
    private func scrollToTopIfNeeded() {
        let topOffset = CGPoint(x: 0, y: -photoCollection.contentInset.top)
        if photoCollection.contentOffset != topOffset {
            photoCollection.setContentOffset(topOffset, animated: true)
        }
    }

    // Setup gesture recognizers for the view (hiding keyboard by tapping the screen)
    private func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // Search photos on query and update the collection
    private func performSearch(with query: String) {
        currentSearchQuery = query
        currentPage = 1
        photos.removeAll()

        guard Reachability.isConnectedToNetwork() else {
            view.makeToast("No internet connection", duration: 3.0, position: .center)
            return
        }

        unsplashService.searchPhotos(query: query) { [weak self] photos in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let photos = photos, !photos.isEmpty {
                    self.photos = photos
                    print("Found \(photos.count) photos")
                } else {
                    print("No photos found")
                    self.view.makeToast("No photos found", duration: 3.0, position: .center)
                    self.searchBar.text = ""
                    self.refreshPhotos()
                    self.photos.removeAll()
                }

                self.photoCollection.reloadData()
                self.photoCollection.setContentOffset(.zero, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: photo.urls.thumb), completed: nil)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let detailVC = PhotoDetailsVC(photo: photo)
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension HomeVC {
    // Creates a compositional layout for the collection view
    private func collectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            // Element size settings
            let fractionalWidth: CGFloat = 0.5
            let fractionalHeight: CGFloat = 0.75
            let groupHeightEstimate: CGFloat = 300
            let interItemSpacing: CGFloat = 16
            let contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 3, bottom: 16, trailing: 3)

            // Configure item size
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(fractionalWidth),
                heightDimension: .fractionalHeight(fractionalHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Configure group size
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(groupHeightEstimate)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item, item]
            )
            group.interItemSpacing = .fixed(interItemSpacing)

            // Configure section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = contentInsets
            section.interGroupSpacing = interItemSpacing

            return section
        }
    }
}

// MARK: - UISearchBarDelegate

extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            print("Query is empty")
            return
        }

        searchBar.resignFirstResponder()
        print("Searching for: \(query)")
        performSearch(with: query)
    }
}

// MARK: - UIScrollViewDelegate

extension HomeVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height, !isFetchingPhotos {
            guard let query = currentSearchQuery else {
                fetchRandomPhotos()
                return
            }
            loadMoreSearchResults(for: query)
        }
    }

    private func loadMoreSearchResults(for query: String) {
        guard !isFetchingPhotos else { return }
        isFetchingPhotos = true
        currentPage += 1

        unsplashService.searchPhotos(query: query, page: currentPage) { [weak self] photos in
            DispatchQueue.main.async {
                self?.isFetchingPhotos = false
                guard let self = self, let photos = photos else {
                    print("No more photos found")
                    return
                }
                self.photos.append(contentsOf: photos)
                self.photoCollection.reloadData()
                print("Loaded more photos. Total now: \(self.photos.count)")
            }
        }
    }
}

private extension HomeVC {
    // Refreshes photos after fetching a new set of random photos

    // Gets random photos and adds them to the photo array

    // Search photos on query and update the collection
}
