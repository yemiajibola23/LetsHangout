//
//  HangoutCollectionViewViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation


struct HangoutCollectionViewViewModel {
    private var hangouts:[Hangout]
    var numberOfHangouts: Int { return hangouts.count }
    
    init(hangouts: [Hangout]) {
        self.hangouts = hangouts
    }
}
