//
//  PlacesViewController.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import UIKit

class PlacesViewController: UIViewController {
    
    //MARK: propirties
    var places: [PlacesModelData] = []
    var menu: [MenuModelData] = []
    private let itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(
      top: 10.0,
      left: 10.0,
      bottom: 10.0,
      right: 10.0)
    
    //MARK: outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkServices.shared.getPlace { (result) in
            switch result {
            case .success(let data):
                self.places = data
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                let alertVC = UIAlertController(
                            title: "Ошибка",
                            message: "Ошибка подключения к серверу",
                            preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        setupCollectionView()
    }
    
    //MARK: private func
    
    func setupCollectionView() {

        collectionView.register(UINib(nibName:  PlacesCell.reuseId, bundle: nil), forCellWithReuseIdentifier:  PlacesCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - extension UICollectionViewDelegate, UICollectionViewDataSource
extension PlacesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlacesCell.reuseId, for: indexPath) as? PlacesCell else { return UICollectionViewCell() }
        
        cell.setCell(with: places[indexPath.item])
        
        return cell
    }
}

// MARK: - extension UICollectionViewDelegateFlowLayout
extension PlacesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * 1.4
        
        return CGSize(width: widthPerItem, height: heightPerItem)
      }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
      return sectionInsets.left
    }
}
