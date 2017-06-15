//
//  FirebaseAuthenticationManagerTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import Firebase
import FirebaseAuth
@testable import LetsHangout

class FirebaseAuthenticationManagerTests: XCTestCase {

    private var manager: FirebaseAuthenticationManager!
    private var hangoutUser: HangoutUser?
    private var authenticationError: FirebaseAuthenticationError?
    
//    let emailArray = ["fake@gmail.com", "fake1@gmail.com","fake2@gmail.com", "fake3@gmail.com", "fake4@gmail.com"]
    
    var userEmail = "fake@gmail.com"
    let userPassword = "dummy1"
    let userName = "Test Dummy 1"
    
    var previousRandomNumber: UInt32?
    
//    private func randomNumber() -> Int {
//        var randomNumber = arc4random_uniform(5)
//        while previousRandomNumber == randomNumber {
//            randomNumber = arc4random_uniform(5)
//        }
//        previousRandomNumber = randomNumber
//        return Int(randomNumber)
//    }
    
    override func setUp() {
        super.setUp()
        manager = FirebaseAuthenticationManagerMock.sharedInstance
//        userEmail = emailArray[randomNumber()]
    }
    
    override func tearDown() {
        self.hangoutUser = nil
        self.authenticationError = nil
        deleteCurrentUser()
        
        super.tearDown()
    }
    
    private func deleteCurrentUser() {
        guard let currentUser = manager.currentUser, let userRef = manager.currentUserRef else { return }
        userRef.removeValue()
        currentUser.delete {
            XCTAssertNil($0)
        }
    }
    
    func testRegisterCredentialsResultHangoutUser() {
        let newUserExpectation = expectation(description: "A new user should be created")
        manager.registerWithCredentials(self.userEmail, self.userPassword, self.userName) { [unowned self] result in
            switch result {
            case  .success(let user): self.hangoutUser = user
            case .failure(let error): self.authenticationError = error
            }
            
            newUserExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { [unowned self] error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(self.authenticationError, self.authenticationError!.message)
            XCTAssertNotNil(self.hangoutUser)
            
            guard let hangoutUser = self.hangoutUser else { return }
            
            XCTAssertEqual(self.userEmail, hangoutUser.email)
            XCTAssertEqual(self.userName, hangoutUser.name)
        }
    }
    
    func testRegisterCredentialsResultErrorEmailAlreadyInUse() {
        let newUserExpectation = expectation(description: "A new user should be created")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.registerWithCredentials(self.userEmail, self.userPassword, self.userName) { [unowned self] result in
                switch result {
                case  .success(let user): self.hangoutUser = user
                case .failure(let error): self.authenticationError = error
                }
                
                newUserExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { (expectationError) in
            XCTAssertNil(expectationError, expectationError!.localizedDescription)
            XCTAssertNotNil(self.authenticationError)
            XCTAssertEqual(self.authenticationError?.type, FirebaseAuthenticationErrorType.emailAlreadyInUse)
            XCTAssertNil(self.hangoutUser)
        }
    }
    
    func testLoginWithCredentialsResultHangoutUser() {
        let loggedInUserExpectation = expectation(description: "A user should be logged in.")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.loginWithCredentials(self.userEmail, self.userPassword) { [unowned self] result in
                switch result {
                case let .success(loggedInUser): self.hangoutUser = loggedInUser
                case let .failure(authError): self.authenticationError = authError
                }
                loggedInUserExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) {[unowned self] error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(self.authenticationError)
            XCTAssertNotNil(self.hangoutUser)
            XCTAssertNotNil(self.manager.currentUser)
            
            guard let user = self.hangoutUser else { return }
            XCTAssertEqual(self.userEmail, user.email)
            XCTAssertEqual(self.userName, user.name)
        }
    }
    
    func testLoginWithCredentialsResultErrorUserNotFound() {
        let authenticationErrorExpectation = expectation(description: "There should be an authentication error")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.loginWithCredentials("random@gmail.com", self.userPassword) { [unowned self] result in
                switch result {
                case let .success(loggedInUser): self.hangoutUser = loggedInUser
                case let .failure(authError): self.authenticationError = authError
                }
                authenticationErrorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNotNil(self.authenticationError)
            XCTAssertEqual(self.authenticationError?.type, FirebaseAuthenticationErrorType.userNotFound)
            XCTAssertNil(self.hangoutUser)
        }
    }
    
    func testLoginWithCredentialsResultErrorWrongPassword() {
        let authenticationErrorExpectation = expectation(description: "There should be an authentication error")
        
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.loginWithCredentials(self.userEmail, "blahblah") { [unowned self] result in
                switch result {
                case let .success(loggedInUser): self.hangoutUser = loggedInUser
                case let .failure(authError): self.authenticationError = authError
                }
                authenticationErrorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { [unowned self] error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNotNil(self.authenticationError)
            XCTAssertEqual(self.authenticationError?.type, FirebaseAuthenticationErrorType.wrongPassword)
            XCTAssertNil(self.hangoutUser)
        }
    }
    
    func testLogoutSuccess() {
        let logoutExpectation = expectation(description: "User should be logged out")
        var authError: FirebaseAuthenticationError?
        
        manager.registerWithCredentials(userEmail, userPassword, userName) { _ in
            self.manager.logout { error in
                if let logoutError = error {
                    authError = logoutError
                }
                logoutExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) {[unowned self] error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(authError, authError!.message)
            XCTAssertNil(self.manager.currentUser)
            XCTAssertNil(self.manager.currentUserRef)
        }
    }
}


