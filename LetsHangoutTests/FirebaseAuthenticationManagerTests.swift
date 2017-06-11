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
    private let userEmail = "fake@gmail.com"
    private let userPassword = "dummy1"
    private let userName = "Test Dummy 1"
    private var manager: FirebaseAuthenticationManager!
    private var hangoutUser: HangoutUser?
    private var authenticationError: FirebaseAuthenticationError?
    
    private var auth: Auth = {
        if FirebaseApp.app() == nil { FirebaseApp.configure() }
        return Auth.auth()
    }()
    
    override func setUp() {
        super.setUp()
        manager = FirebaseAuthenticationManagerMock.sharedInstance
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
        currentUser.delete { XCTAssertNil($0) }
    }
    
    func testRegisterCredentialsResultHangoutUser() {
        let tempEmail = "fake1@gmail.com"
        let tempPassword = "dummy2"
        let tempName = "Dummy 2"
        
        let newUserExpectation = expectation(description: "A new user should be created")
        manager.registerWithCredentials(tempEmail, tempPassword, tempName) { [unowned self] result in
            switch result {
            case  .success(let user): self.hangoutUser = user
            case .failure(let error): self.authenticationError = error
            }
            
            newUserExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { [unowned self] error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(self.authenticationError)
            XCTAssertNotNil(self.hangoutUser)
            XCTAssertEqual(tempEmail, self.hangoutUser?.email)
            XCTAssertEqual(tempName, self.hangoutUser?.name)
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
            XCTAssertEqual(self.userEmail, self.hangoutUser?.email)
            XCTAssertEqual(self.userName, self.hangoutUser?.name)
        }
    }
    
    func testLoginWithCredentialsResultErrorUserNotFound() {
        let authenticationErrorExpectation = expectation(description: "There should be an authentication error")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.loginWithCredentials("fake2@gmail.com", self.userPassword) { [unowned self] result in
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
            XCTAssertEqual(self.authenticationError!.type, FirebaseAuthenticationErrorType.userNotFound)
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


