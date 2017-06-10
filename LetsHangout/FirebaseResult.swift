//
//  FirebaseResult.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation

enum Result<T, Error> {
    case success(T)
    case failure(Error)
    
}
