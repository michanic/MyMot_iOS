//
//  LoadingViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ImagesViewerController: UniversalViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: Images
    var currentIndex: Int = 0
    var willDisplayingIndex: Int = -1
    var indexChangedCallback: ((Int) -> ())?
    
    lazy var prevButton = UIBarButtonItem(image: UIImage(named: "nav_left"), style: .plain, target: self, action: #selector(showPrev))
    lazy var nextButton = UIBarButtonItem(image: UIImage(named: "nav_right"), style: .plain, target: self, action: #selector(showNext))
    
    init(images: Images, currentIndex: Int, indexChangedCallback: ((Int) -> ())?) {
        self.images = images
        self.currentIndex = currentIndex
        self.indexChangedCallback = indexChangedCallback
        super.init(nibName: nil, bundle: nil)
        self.darkStyle = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.black
        collectionView.register(UINib(nibName: "ImagesViewerCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "images_viewer_collection_cell")
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkButtons()
        navigationItem.rightBarButtonItems = [nextButton, prevButton]
        collectionView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        UIView.animate(withDuration: 0.2) {
            self.collectionView.alpha = 1
        }
    }
    
    @objc private func showPrev() {
        switchToImage(index: currentIndex - 1)
    }
    
    @objc private func showNext() {
        switchToImage(index: currentIndex + 1)
    }
    
    private func switchToImage(index: Int) {
        guard index >= 0 && index < images.count else { return }
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
        currentIndex = index
    }
    
    private func checkButtons() {
        prevButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < images.count - 1
    }
}

extension ImagesViewerController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "images_viewer_collection_cell", for: indexPath) as! ImagesViewerCollectionViewCell
        cell.setupWithImagePath(images[indexPath.row]) { [weak self] (imageZoomed) in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.isScrollEnabled = !imageZoomed
            strongSelf.navigationController?.setNavigationBarHidden(imageZoomed, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayingIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if willDisplayingIndex != indexPath.row {
            currentIndex = willDisplayingIndex
            indexChangedCallback?(currentIndex)
            willDisplayingIndex = -1
            checkButtons()
        }
    }

}

extension ImagesViewerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
