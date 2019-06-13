//
//  VideoViewerController.swift
//  MyMot
//
//  Created by Michail Solyanic on 11/06/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoViewerController: UniversalViewController, YouTubePlayerDelegate {
    
    var video: YoutubeVideo
    @IBOutlet var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    init(video: YoutubeVideo) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
        self.darkStyle = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = "Видеообзор"
        
        indicator.startAnimating()
        if let url = URL(string: video.videoPath) {
            videoPlayer.loadVideoURL(url)
            videoPlayer.delegate = self
        }
        //videoPlayer.loadVideoID(video.videoId)
        
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        //videoPlayer.play()
        indicator.stopAnimating()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        
        if playerState.rawValue == "2" {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        print("state " + playerState.rawValue)
    }
}
