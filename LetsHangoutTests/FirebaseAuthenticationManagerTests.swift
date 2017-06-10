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
    private let userPasssword = "dummy1"
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
        manager.registerWithCredentials(userEmail, userPasssword, userName) { result in
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
        manager.registerWithCredentials(userEmail, userPasssword, userName) { [unowned self] _ in
            self.manager.registerWithCredentials(self.userEmail, self.userPasssword, self.userName) { result in
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
            XCTAssertEqual(authenticationError!.type, FirebaseAuthenticationErrorType.emailAlreadyInUse)
            XCTAssertNil(hangoutUser)
        }
    }
    
//    func testLoginWithCredentialsResultHangoutUser() {
//        var hangoutUser: HangoutUser?
//        var authenticationError: FirebaseAuthenticationError?
//        let newUserExpectation = expectation(description: "A new user should be created")
//        manager.registerWithCredentials(userEmail, userPasssword, userName) { result in
//            switch result {
//            case  .success(let user): hangoutUser = user
//            case .failure(let error): authenticationError = error
//            }
//            
//            newUserExpectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 30) { (error) in
//            XCTAssertNil(error, error!.localizedDescription)
//            XCTAssertNil(authenticationError)
//            XCTAssertNotNil(hangoutUser)
//            XCTAssertEqual(self.userEmail, hangoutUser?.email)
//            XCTAssertEqual(self.userName, hangoutUser?.name)
//        }
//    }
}

extension FirebaseAuthenticationManagerTests {
    class FirebaseAuthenticationManagerMock: FirebaseAuthenticationManager {
        var registrationResult: AuthenticationResult?
        var registeredUser: HangoutUser?
        var registrationError: FirebaseAuthenticationError?
        var loggedInUser: HangoutUser?
        var loginError: FirebaseAuthenticationError?
        var loginResult: AuthenticationResult?
        
        override func registerWithCredentials(_ email: String, _ password: String, _ name: String, completion: @escaping (AuthenticationResult) -> Void) {
            super.registerWithCredentials(email, password, name) {[unowned self] (result) in
                self.registrationResult = result
                
                switch result {
                case .success(let newUser): self.registeredUser = newUser
                case .failure(let authError): self.registrationError = authError
                }
            }
        }
        
        
        override func loginWithCredentials(_ email: String, _ password: String, completion: @escaping (AuthenticationResult) -> Void) {
            super.loginWithCredentials(email, password) {[unowned self] (result) in
                self.loginResult = result
                
                switch result {
                case .success(let user): self.loggedInUser = user
                case .failure(let error): self.loginError = error
                }
            }
        }
    }
}
