//
//  TimerModel.swift
//  BoxingTimer
//
//  Created by 최광훈 on 04/08/2019.
//  Copyright © 2019 인우 최. All rights reserved.
//

import UIKit

class TimerModel: NSObject
{
    var round = 12
    var playTime = 3 * 60
    var breakTime = 30
    var vibration = true
    var sound = true
    
    override init()
    {
        
    }
    
    init(dictionary:NSDictionary) {
        round = dictionary["round"] as! Int
        playTime = dictionary["playTime"] as! Int
        breakTime = dictionary["breakTime"] as! Int
        vibration = dictionary["vibration"] as! Bool
        sound = dictionary["sound"] as! Bool
    }
    
    func getDictionary() -> NSDictionary {
        return ["round":NSNumber(value: round),
                "playTime":NSNumber(value: playTime),
                "breakTime":NSNumber(value: breakTime),
                "vibration":NSNumber(value: vibration),
                "sound":NSNumber(value: sound)]
    }
}
