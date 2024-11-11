//
//  FavouritesVC.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import CoreData
import UIKit

final class FavouritesVC: UIViewController {
    private var savedPhotos: [Photo] = []

    // MARK: - UI Elements

    private lazy var savedPhotosTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.register(SavedPhotoCell.self, forCellReuseIdentifier: "SavedPhotoCell")
        return table
    }()

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView(image: .notFound, message: "No favourite photos")
        view.isHidden = true
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        setupProperties()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedPhotos()
    }
}

// MARK: - BaseVCProtocol

extension FavouritesVC: BaseVCProtocol {
    func setupView() {
        view.addSubviews(savedPhotosTable, emptyStateView)
    }

    func makeConstraints() {
        savedPhotosTable.anchor(top: view.topAnchor,
                                left: view.leftAnchor,
                                bottom: view.bottomAnchor,
                                right: view.rightAnchor)

        emptyStateView.anchor(width: 200, height: 200)
        emptyStateView.centerX(inView: view)
        emptyStateView.centerY(inView: view)
    }

    func setupProperties() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Favourites"
        navigationItem.largeTitleDisplayMode = .always
    }
}

// MARK: - Private Methods

private extension FavouritesVC {
    // Getting saved photo from Core Data
    private func loadSavedPhotos() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<SavedPhoto> = SavedPhoto.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            savedPhotos = results.map { $0.toPhoto() }
            savedPhotosTable.reloadData()
            updateEmptyStateViewVisibility()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            updateEmptyStateViewVisibility(show: true)
        }
    }

    // Method to update the visibility of noDataImageView
    private func updateEmptyStateViewVisibility(show: Bool = false) {
        emptyStateView.isHidden = !show && !savedPhotos.isEmpty
    }

    // Deleting photo from Core Data
    private func deletePhoto(at indexPath: IndexPath) {
        let photo = savedPhotos[indexPath.row]
        PhotoCoreDataService.shared.removePhoto(photo)
        savedPhotos.remove(at: indexPath.row)

        savedPhotosTable.deleteRows(at: [indexPath], with: .automatic)
        updateEmptyStateViewVisibility() // Обновление состояния представления после удаления
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension FavouritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPhotos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPhotoCell", for: indexPath) as! SavedPhotoCell
        let photo = savedPhotos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = savedPhotos[indexPath.row]
        let detailVC = PhotoDetailsVC(photo: photo)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Handling swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.deletePhoto(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }

    // Height for rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
}

// MARK: - PhotoDetailsVCDelegate

extension FavouritesVC: PhotoDetailsVCDelegate {
    func photoDetailsVCDidDismiss() {
        loadSavedPhotos()
    }
}
