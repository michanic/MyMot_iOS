//
//  SearchFeedCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ImagesViewerCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    private var imageZoomed: ((Bool) -> ())?
    
    func setupWithImagePath(_ path: String, imageZoomed: ((Bool) -> ())?) {
        self.imageZoomed = imageZoomed
        imageView.contentMode = .center
        imageView.setImage(path: path, placeholder: nil) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.imageView.contentMode = .scaleAspectFit
            strongSelf.configZoom()
        }
    }
    
    func configZoom() {
        guard let imageSize = imageView.image?.size else { return }
        //let minScale = scrollView.frame.size.width / imageSize.width;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 3.0;
        scrollView.contentSize = imageSize;
        scrollView.delegate = self;
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            scrollView.isScrollEnabled = true
            imageZoomed?(true)
        } else {
            scrollView.isScrollEnabled = false
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {

    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale <= 1 {
            imageZoomed?(false)
        }
    }
}
