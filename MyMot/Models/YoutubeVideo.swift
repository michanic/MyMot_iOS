//
//  YoutubeVideo.swift
//  MyMot
//
//  Created by Michail Solyanic on 11/06/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

typealias Videos = [YoutubeVideo]

class YoutubeVideo {

    let videoId: String
    var previewPath: String { return "https://img.youtube.com/vi/\(videoId)/mqdefault.jpg" }
    var videoPath: String { return "https://www.youtube.com/watch?v="+videoId }
    
    init(videoId: String) {
        self.videoId = videoId
    }
    
}
