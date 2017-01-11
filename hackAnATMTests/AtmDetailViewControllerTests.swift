//
//  AtmDetailViewControllerTests.swift
//  AtmViewer
//
//  Created by xavier on 1/10/17.
//  Copyright © 2017 John. All rights reserved.
//

import XCTest
@testable import AtmViewer
import Alamofire
import SwiftyJSON


class AtmDetailViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFormatPhoneNumber() {
        let atmDetailVC = AtmDetailViewController()
        
        let phoneNumberFormatted = atmDetailVC.cleanPhoneNumberString(phoneString: "9162028430")
        
        XCTAssertEqual(phoneNumberFormatted, "(916)-202-8430")
        
    }
    
    //With Hours
    func testHoursTextWithHours() {
        
        let hoursJson = JSON(dictionaryLiteral: ("hours", ["8:00-7:00",
                                                           "8:00-7:00",
                                                           "8:00-7:00",
                                                           "8:00-7:00",
                                                           "8:00-7:00",
                                                           "9:00-2:00"]))
        let atmDetailVC = AtmDetailViewController()
        let hoursTextFormatted = atmDetailVC.hoursText(hoursJson["hours"].arrayValue)
        
        let answerString = "Hours: \nMon: 8:00-7:00\nTues: 8:00-7:00\nWed: 8:00-7:00\nThurs: 8:00-7:00\nFri: 8:00-7:00\nSat&Sun: 9:00-2:00"
        
        XCTAssertEqual(hoursTextFormatted, answerString)
        
    }
    
    //No Hours
    func testHoursTextWithOutHours() {
        
        let hoursJson = JSON(dictionaryLiteral: ("hours", [""]))
        let atmDetailVC = AtmDetailViewController()
        let hoursTextFormatted = atmDetailVC.hoursText(hoursJson["hours"].arrayValue)
        
        let answerString = "Hours: \n No Hours Listed"
        
        XCTAssertEqual(hoursTextFormatted, answerString)
        
    }
    
    //With Services
    func testServiceWithText() {
        
        let serviceJson = JSON(dictionaryLiteral: ("service", ["Open 24 hours",
                                                               "Deposit ATM",
                                                               "Audio-assisted ATM",
                                                               "Deposit-friendly"]))
        let atmDetailVC = AtmDetailViewController()
        let serviceTextFormatted = atmDetailVC.serviceText(serviceJson["service"].arrayValue)
        
        let answerString = "Services: \nOpen 24 hours\nDeposit ATM\nAudio-assisted ATM\nDeposit-friendly"
        
        XCTAssertEqual(serviceTextFormatted, answerString)
        
    }
    
    //No Services
    func testServiceWithOutText() {
        
        let serviceJson = JSON(dictionaryLiteral: ("service", [""]))
        let atmDetailVC = AtmDetailViewController()
        let serviceTextFormatted = atmDetailVC.serviceText(serviceJson["service"].arrayValue)
        
        let answerString = "Services: \n No Services Listed"
        
        XCTAssertEqual(serviceTextFormatted, answerString)
        
    }
    
    
    
}
