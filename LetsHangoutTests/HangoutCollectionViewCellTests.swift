//
//  HangoutCollectionViewCellTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
@testable import LetsHangout

class HangoutCollectionViewCellTests: XCTestCase {
    
    var cell: HangoutCollectionViewCell!
    
    override func setUp() {
        super.setUp()
        let controller = HangoutListViewController(nibName: HangoutListViewController.nibName, bundle: nil)
        let _ = controller.view
        let collectionView = controller.hangoutCollectionView
        let fakeDataSource = FakeDataSource()
        collectionView?.dataSource = fakeDataSource
        
        cell = collectionView?.dequeueReusableCell(withReuseIdentifier: HangoutCollectionViewCell.reuseIdentifier, for: IndexPath(item: 0, section: 0)) as! HangoutCollectionViewCell
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCellNameLabel() {
        XCTAssertNotNil(cell.nameLabel)
    }
}

extension HangoutCollectionViewCellTests {
    class FakeDataSource: NSObject, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
    }
}
