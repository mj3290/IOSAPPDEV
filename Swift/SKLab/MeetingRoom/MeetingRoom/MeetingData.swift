//
//  MeetingData.swift
//  MeetingRoom
//
//  Created by Kim Dong-woo on 2017. 4. 13..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import Foundation


struct Meeting {
    var title:String = ""
    var capacity:Int = 0
}

let MeetingRooms = [
    Meeting( title : "room1", capacity : 10),
    Meeting( title : "room2", capacity : 5),
    Meeting( title : "room3", capacity : 4),
    Meeting( title : "room4", capacity : 6),
    Meeting( title : "room5", capacity : 12),
]


let SeminarRooms = [
    Meeting( title : "sroom1", capacity : 11),
    Meeting( title : "sroom2", capacity : 15),
    Meeting( title : "sroom3", capacity : 14),
    Meeting( title : "sroom4", capacity : 16),
    Meeting( title : "sroom5", capacity : 22),
]
