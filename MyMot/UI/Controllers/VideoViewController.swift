//
//  VideoViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 13/06/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: UniversalViewController {

    var video: YoutubeVideo
    @IBOutlet weak var webVIew: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    init(video: YoutubeVideo) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle = "Видеообзор"
        webVIew.navigationDelegate = self
        webVIew.isHidden = true
        indicator.startAnimating()
        
        if let url = URL(string: "https://www.youtube.com/embed/\(video.videoId)?rel=0&amp;autoplay=1") {
            webVIew.load(URLRequest(url: url))
        }
        
    }

    
    
}

extension VideoViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webVIew.isHidden = false
        indicator.stopAnimating()
    }
    
}
