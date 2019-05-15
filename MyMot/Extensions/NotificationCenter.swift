//
//  NotificationCenter.swift
//  MyMot
//
//  Created by Michail Solyanic on 05/02/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

class NotificationSubscriber {
    
    var receiver: ((Any?) -> ())
    var types: [NotificationType]
    
    init(types: [NotificationType], received: @escaping ((Any?) -> ())) {
        self.receiver = received
        self.types = types
    }
    
    @objc func notificationReceived(notification: Notification) {
        receiver(notification.object)
    }
    
    deinit {
        print("NotificationSubscriber deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension NotificationCenter {
    
    static func post(type: NotificationType, object: Any?) {
        NotificationCenter.default.post(name: Notification.Name(type.rawValue), object: object)
    }
 
    static func subscribe(_ subscriber: NotificationSubscriber) {
        for type in subscriber.types {
            NotificationCenter.default.addObserver(subscriber, selector: #selector(NotificationSubscriber.notificationReceived(notification:)), name: NSNotification.Name.init(type.rawValue), object: nil)
        }
    }
    
}
