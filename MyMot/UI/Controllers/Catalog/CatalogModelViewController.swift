//
//  CatalogModelViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogModelViewController: UniversalViewController {

    @IBOutlet weak var imagesSlider: ImagesSliderView!
    @IBOutlet weak var imagesSliderWidth: NSLayoutConstraint!
    @IBOutlet weak var imagesSliderHeight: NSLayoutConstraint!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var parametersView: UIStackView!
    @IBOutlet weak var parametersViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reviewsTitle: UILabel!
    @IBOutlet weak var reviewsTitleBottom: NSLayoutConstraint!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var reviewsCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewsCollectionBottom: NSLayoutConstraint!
    
    let model: Model
    var modelDetails: ModelDetails?
    
    lazy var orientationChangedSubscriber = NotificationSubscriber(types: [.screenOrientationChanged], received: { (object) in
        guard let modelDetails = self.modelDetails else { return }
        self.drawParametersView(modelDetails.parameters)
    })
    
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.subscribe(orientationChangedSubscriber)
        self.navBarTitle = (model.name ?? "")
        
        let cellName = String(describing: CellType.youtubeVideo.cellClass)
        reviewsCollectionView.register(UINib(nibName: cellName, bundle: Bundle.main), forCellWithReuseIdentifier: cellName)
        
        updateFavouriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if modelDetails == nil {
            showLoading()
            let apiInteractor = ApiInteractor()
            apiInteractor.loadModelDetails(modelId: Int(model.id)) { (details) in
                self.modelDetails = details
                self.fillProperties()
                self.hideLoading()
            }
        }
    }

    @objc func toFavourite() {
        model.favourite =  !model.favourite
        CoreDataManager.instance.saveContext()
        NotificationCenter.post(type: .favouriteModelSwitched, object: model)
        updateFavouriteButton()
    }
    
    @objc func showImagesGallery() {
        if let modelDetails = modelDetails {
            let indexChangedCallback = { newPageIndex in
                self.imagesSlider.changePage(newPage: newPageIndex)
            }
            Router.shared.presentController(ViewControllerFactory.imagesViewer(modelDetails.bigImages, imagesSlider.getCurrentPage(), indexChangedCallback).create)
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        var searchConfig = ConfigStorage.getFilterConfig()
        searchConfig.selectedModel = model
        ConfigStorage.saveFilterConfig(searchConfig)
        Router.shared.pushController(ViewControllerFactory.searchResults(searchConfig).create)
    }
    
    private func updateFavouriteButton() {
        if model.favourite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_favourite_active")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toFavourite))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_favourite_passive")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toFavourite))
        }
    }

    private func fillProperties() {
        guard let modelDetails = modelDetails else { return }
        
        imagesSliderWidth.constant = Screen.minSide
        imagesSliderHeight.constant = Screen.minSide * 0.75 + 37
        view.layoutIfNeeded()
        
        imagesSlider.fillWithImages(modelDetails.images, contentMode: .scaleAspectFill)
        imagesSlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagesGallery)))
        modelLabel.text = model.name
        manufacturerLabel.text = model.manufacturer?.name
        classLabel.text = model.category?.name
        yearsLabel.text = model.years
        if let detailsText = modelDetails.text, detailsText.count > 0 {
            aboutLabel.text = modelDetails.text
            aboutLabelBottom.constant = 50
        } else {
            aboutLabel.text = nil
            aboutLabelBottom.constant = 0
        }
        drawParametersView(modelDetails.parameters)
        drawVideos(modelDetails.videos)
    }
    
    private func drawParametersView(_ parameters: Parameters) {
        
        parametersView.clearSubviews()
        
        let captionWidth = (Screen.width - 26 - 32 - 10) * 0.4
        let valueWidth = (Screen.width - 26 - 32 - 10) * 0.6
        var posY: CGFloat = 0
        
        for parameter in parameters {
            
            let captionHeight = parameter.0.getHeightFor(width: captionWidth, font: UIFont.systemFont(ofSize: 14))
            let valueHeight = parameter.1.getHeightFor(width: valueWidth, font: UIFont.systemFont(ofSize: 12))
            var viewHeight: CGFloat = 0
            if captionHeight > valueHeight {
                viewHeight = captionHeight + 24.0
            } else {
                viewHeight = valueHeight + 24.0
            }
            
            let backView = UIView(frame: CGRect(x: 0, y: posY, width: Screen.width, height: viewHeight))
            
            let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: 0.5))
            separatorView.backgroundColor = UIColor.separatorGray
            backView.addSubview(separatorView)
            
            let captionLabel = UILabel(frame: CGRect(x: 26, y: 12, width: captionWidth, height: captionHeight))
            captionLabel.font = UIFont.systemFont(ofSize: 14)
            captionLabel.numberOfLines = 0
            captionLabel.textColor = UIColor.textDarkGray
            captionLabel.text = parameter.0
            backView.addSubview(captionLabel)
            
            let valueLabel = UILabel(frame: CGRect(x: Screen.width - valueWidth - 32, y: 12, width: valueWidth, height: valueHeight))
            valueLabel.font = UIFont.systemFont(ofSize: 12)
            valueLabel.numberOfLines = 0
            valueLabel.textColor = UIColor.textLightGray
            valueLabel.text = parameter.1
            backView.addSubview(valueLabel)
            
            parametersView.addSubview(backView)
            posY += backView.frame.height
            
        }
        parametersViewHeight.constant = posY
    }
    
    private func drawVideos(_ videos: Videos) {
        if videos.isEmpty {
            reviewsTitle.text = nil
            reviewsTitleBottom.constant = 0
            reviewsCollectionHeight.constant = 0
            reviewsCollectionBottom.constant = 0
        } else {
            reviewsTitle.text = "Видеообзоры:"
            reviewsTitleBottom.constant = 16
            reviewsCollectionHeight.constant = 100
            reviewsCollectionBottom.constant = 50
            reviewsCollectionView.reloadData()
        }
    }
}

extension CatalogModelViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelDetails?.videos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let video = modelDetails?.videos[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CellType.youtubeVideo.cellClass), for: indexPath) as! YoutubeVideoCell
            cell.fillWithContent(content: video, eventListener: nil)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let video = modelDetails?.videos[indexPath.row] {
            Router.shared.pushController(ViewControllerFactory.videoViewer(video).create)
        }
    }
    
}
