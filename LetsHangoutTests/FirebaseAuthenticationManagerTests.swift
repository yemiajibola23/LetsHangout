//
//  FirebaseAuthenticationManagerTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import Firebase
@testable import LetsHangout

class FirebaseAuthenticationManagerTests: XCTestCase {
    private let userEmail = "fake@gmail.com"
    private let userPassword = "dummy1"
    private let userName = "Test Dummy 1"
    private var manager: FirebaseAuthenticationManager!
    
    override func setUp() {
        super.setUp()
        manager = FirebaseAuthenticationManagerMock.sharedInstance
    }
    
    override func tearDown() {
        deleteCurrentUser()
        super.tearDown()
    }
    
    private func deleteCurrentUser() {
        guard let currentUser = manager.currentUser, let userRef = manager.currentUserRef else { return }
        userRef.removeValue()
        currentUser.delete { XCTAssertNil($0) }
    }
    
    func testRegisterCredentialsResultHangoutUser() {
        var hangoutUser: HangoutUser?
        var authenticationError: FirebaseAuthenticationError?
        let newUserExpectation = expectation(description: "A new user should be created")
        manager.registerWithCredentials(userEmail, userPassword, userName) { result in
            switch result {
            case  .success(let user): hangoutUser = user
            case .failure(let error): authenticationError = error
            }
            
            newUserExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(authenticationError)
            XCTAssertNotNil(hangoutUser)
            XCTAssertEqual(self.userEmail, hangoutUser?.email)
            XCTAssertEqual(self.userName, hangoutUser?.name)
        }
    }
    
    func testRegisterCredentialsResultErrorEmailAlreadyInUse() {
        var hangoutUser: HangoutUser?
        var authenticationError: FirebaseAuthenticationError?
        let newUserExpectation = expectation(description: "A new user should be created")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.registerWithCredentials(self.userEmail, self.userPassword, self.userName) { result in
                switch result {
                case  .success(let user): hangoutUser = user
                case .failure(let error): authenticationError = error
                }
                
                newUserExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { (expectationError) in
            XCTAssertNil(expectationError, expectationError!.localizedDescription)
            XCTAssertNotNil(authenticationError)
            XCTAssertEqual(authenticationError?.type, FirebaseAuthenticationErrorType.emailAlreadyInUse)
            XCTAssertNil(hangoutUser)
        }
    }
    
    func testLoginWithCredentialsResultHangoutUser() {
        var hangoutUser: HangoutUser?
        var authenticationError: FirebaseAuthenticationError?
        let loggedInUserExpectation = expectation(description: "A user should be logged in.")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.loginWithCredentials(self.userEmail, self.userPassword) { result in
                switch result {
                case let .success(loggedInUser): hangoutUser = loggedInUser
                case let .failure(authError): authenticationError = authError
                }
                loggedInUserExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(authenticationError)
            XCTAssertNotNil(hangoutUser)
            XCTAssertNotNil(self.manager.currentUser)
            XCTAssertEqual(self.userEmail, hangoutUser?.email)
            XCTAssertEqual(self.userName, hangoutUser?.name)
        }
    }
    
    func testLoginWithCredentialsResultErrorUserNotFound() {
        var hangoutUser: HangoutUser?
        var authenticationError: FirebaseAuthenticationError?
        let authenticationErrorExpectation = expectation(description: "There should be an authentication error")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.loginWithCredentials("fake2@gmail.com", self.userPassword) { result in
                switch result {
                case let .success(loggedInUser): hangoutUser = loggedInUser
                case let .failure(authError): authenticationError = authError
                }
                authenticationErrorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNotNil(authenticationError)
            XCTAssertEqual(authenticationError!.type, FirebaseAuthenticationErrorType.userNotFound)
            XCTAssertNil(hangoutUser)
        }
    }
    
    func testLoginWithCredentialsResultErrorWrongPassword() {
        var hangoutUser: HangoutUser?
        var authenticationError: FirebaseAuthenticationError?
        let authenticationErrorExpectation = expectation(description: "There should be an authentication error")
        manager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.manager.loginWithCredentials(self.userEmail, "blahblah") { result in
                switch result {
                case let .success(loggedInUser): hangoutUser = loggedInUser
                case let .failure(authError): authenticationError = authError
                }
                authenticationErrorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNotNil(authenticationError)
            XCTAssertEqual(authenticationError!.type, FirebaseAuthenticationErrorType.wrongPassword)
            XCTAssertNil(hangoutUser)
        }
    }
}

extension FirebaseAuthenticationManagerTests {
    class FirebaseAuthenticationManagerMock: FirebaseAuthenticationManager {
        var authenticationResult: AuthenticationResult?
        var authenticatedUser: HangoutUser?
        var authenticationError: FirebaseAuthenticationError?
        
        
        override func registerWithCredentials(_ email: String, _ password: String, _ name: String, completion: @escaping (AuthenticationResult) -> Void) {
            super.registerWithCredentials(email, password, name) {[unowned self] result in
                self.authenticationResult = result
                
                switch result {
                case .success(let newUser): self.authenticatedUser = newUser
                case .failure(let authError): self.authenticationError = authError
                }
            }
        }
        
        
        override func loginWithCredentials(_ email: String, _ password: String, completion: @escaping (AuthenticationResult) -> Void) {
            super.loginWithCredentials(email, password) {[unowned self] (result) in
                self.authenticationResult = result
                
                switch result {
                case .success(let user): self.authenticatedUser = user
                case .failure(let error): self.authenticationError = error
                }
            }
        }
    }
}
