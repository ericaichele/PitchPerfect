//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Eric Aichele on 3/16/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title:String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
