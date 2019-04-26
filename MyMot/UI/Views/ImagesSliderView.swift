//
//  ImagesSliderView.swift
//  MyMot
//
//  Created by Michail Solyanic on 12/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ImagesSliderView: UIView {

    var images: Images = []
    var currentImage: Int = 0
    var imagesContentMode: UIView.ContentMode = .scaleAspectFill
    
    lazy var indicatorView = UIActivityIndicatorView(style: .gray)
    lazy var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: self.bounds.height - 37))
    lazy var pagerView = UIPageControl(frame: CGRect(x: 0, y: self.bounds.height - 37, width: UIScreen.width, height: 37))
    
    func fillWithImages(_ images: Images, contentMode: UIView.ContentMode) {
        self.images = images
        self.imagesContentMode = contentMode
        if subviews.count == 0 {
            createElements()
        }
    }

    private func createElements() {
        indicatorView.frame = CGRect(x: scrollView.bounds.width / 2 - 10, y: scrollView.bounds.height / 2 - 10, width: 20, height: 20)
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.width * CGFloat(images.count), height: scrollView.bounds.height)
        addSubview(scrollView)
        
        pagerView.pageIndicatorTintColor = UIColor(white: 216.0 / 255.0, alpha: 1.0)
        pagerView.currentPageIndicatorTintColor = UIColor(white: 128.0 / 255.0, alpha: 1.0)
        pagerView.numberOfPages = images.count
        pagerView.currentPage = currentImage
        pagerView.addTarget(self, action: #selector(pageChangePressed), for: .valueChanged)
        addSubview(pagerView)
        
        createImageViews()
    }
    
    private func createImageViews() {
        var index: Int = 0
        for image in images {
            let imageView = UIImageView(frame: CGRect(x: UIScreen.width * CGFloat(index), y: 0, width: UIScreen.width, height: scrollView.bounds.height))
            imageView.contentMode = imagesContentMode
            imageView.setImage(path: image, placeholder: nil)
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
            index += 1
        }
    }

    @objc func pageChangePressed() {
        let posX = CGFloat(pagerView.currentPage) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: posX, y: 0), animated: true)
    }
}

extension ImagesSliderView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagerView.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
}
