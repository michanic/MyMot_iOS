//
//  UniversalViewController+KRPullLoadViewDelegate.swift
//  MyMot
//
//  Created by Michail Solyanic on 07/05/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import KRPullLoader

extension UniversalViewController: KRPullLoadViewDelegate {
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        switch state {
        case let .loading(completionHandler):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                if type == .loadMore {
                    if let loadMore = self.loadMoreDelegate?.loadMoreAvailable, loadMore {
                        self.loadMoreDelegate?.loadMoreCompletionHandler = completionHandler
                        self.loadMoreDelegate?.loadMore()
                    } else {
                        completionHandler()
                    }
                } else {
                    self.refreshDelegate?.refreshCompletionHandler = completionHandler
                    self.refreshDelegate?.refreshPulled()
                }
            }
        default: break
        }
        
    }
    
    func refreshSetEnabled(_ enabled: Bool) {
        if let customCollectionView = customCollectionView {
            if enabled {
                customCollectionView.addPullLoadableView(refreshView, type: .refresh)
            } else {
                customCollectionView.removePullLoadableView(refreshView)
            }
        } else {
            if enabled {
                tableView.addPullLoadableView(refreshView, type: .refresh)
            } else {
                tableView.removePullLoadableView(refreshView)
            }
        }
    }
    
    func loadMoreSetEnabled(_ enabled: Bool) {
        if let customCollectionView = customCollectionView {
            if enabled {
                customCollectionView.addPullLoadableView(loadMoreView, type: .loadMore)
            } else {
                customCollectionView.removePullLoadableView(loadMoreView)
            }
        } else {
            if enabled {
                tableView.addPullLoadableView(loadMoreView, type: .loadMore)
            } else {
                tableView.removePullLoadableView(loadMoreView)
            }
        }
    }
}
