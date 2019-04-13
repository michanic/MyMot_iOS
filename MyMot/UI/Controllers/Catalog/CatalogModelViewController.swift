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
    @IBOutlet weak var imagesSliderHeight: NSLayoutConstraint!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var parametersView: UIStackView!
    @IBOutlet weak var parametersViewHeight: NSLayoutConstraint!
    
    let model: Model
    var modelDetails: ModelDetails?
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = (model.name ?? "")
        
        updateFavouriteButton()
        
        let apiInteractor = ApiInteractor()
        apiInteractor.loadModelDetails(modelId: Int(model.id)) { (details) in
            self.modelDetails = details
            self.fillProperties()
        }
    }

    @objc func toFavourite() {
        model.favourite =  !model.favourite
        CoreDataManager.instance.saveContext()
        updateFavouriteButton()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
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
        imagesSliderHeight.constant = UIScreen.width * 0.75 + 37
        view.layoutIfNeeded()
        
        imagesSlider.fillWithImages(modelDetails.images)
        modelLabel.text = model.name
        manufacturerLabel.text = model.manufacturer?.name
        classLabel.text = model.category?.name
        yearsLabel.text = model.years
        aboutLabel.text = modelDetails.text
        drawParametersView(modelDetails.parameters)
    }
    
    private func drawParametersView(_ parameters: Parameters) {
        
        let captionWidth = (UIScreen.width - 26 - 32 - 10) * 0.4
        let valueWidth = (UIScreen.width - 26 - 32 - 10) * 0.6
        var posY: CGFloat = 0
        
        for parameter in parameters {
            
            let captionHeight = parameter.key.getHeightFor(width: captionWidth, font: UIFont.systemFont(ofSize: 14))
            let valueHeight = parameter.value.getHeightFor(width: valueWidth, font: UIFont.systemFont(ofSize: 12))
            var viewHeight: CGFloat = 0
            if captionHeight > valueHeight {
                viewHeight = captionHeight + 24.0
            } else {
                viewHeight = valueHeight + 24.0
            }
            
            let backView = UIView(frame: CGRect(x: 0, y: posY, width: UIScreen.width, height: viewHeight))
            
            let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 0.5))
            separatorView.backgroundColor = UIColor.separatorGray
            backView.addSubview(separatorView)
            
            let captionLabel = UILabel(frame: CGRect(x: 26, y: 12, width: captionWidth, height: captionHeight))
            captionLabel.font = UIFont.systemFont(ofSize: 14)
            captionLabel.numberOfLines = 0
            captionLabel.textColor = UIColor.textDarkGray
            captionLabel.text = parameter.key
            backView.addSubview(captionLabel)
            
            let valueLabel = UILabel(frame: CGRect(x: UIScreen.width - valueWidth - 32, y: 12, width: valueWidth, height: valueHeight))
            valueLabel.font = UIFont.systemFont(ofSize: 12)
            valueLabel.numberOfLines = 0
            valueLabel.textColor = UIColor.textLightGray
            valueLabel.text = parameter.value
            backView.addSubview(valueLabel)
            
            parametersView.addSubview(backView)
            posY += backView.frame.height
            
        }
        parametersViewHeight.constant = posY
    }
}
