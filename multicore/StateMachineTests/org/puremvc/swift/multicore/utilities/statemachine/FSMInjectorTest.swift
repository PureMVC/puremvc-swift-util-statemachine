//
//  FSMInjectorTest.swift
//  PureMVC SWIFT MultiCore Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
import StateMachine

class FSMInjectorTest: XCTestCase {
    
    static let STATE1: String = "state1"
    static let ENTER1: String = "enter1"
    static let ACTION1: String = "action1"
    static let TARGET1: String = "target1"
    
    static let STATE2: String = "state2"
    static let ENTER2: String = "enter2"
    static let ACTION2: String = "action2"
    static let TARGET2: String = "target2"
    
    static let STATE3: String = "state3"
    static let ENTER3: String = "enter3"
    static let ACTION3: String = "action3"
    static let TARGET3: String = "target3"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructors() {
        let fsm: String =
        "<fsm initial=''>" +
            "<state name='\(FSMInjectorTest.STATE1)' entering='\(FSMInjectorTest.ENTER1)'>" +
                "<transition action='\(FSMInjectorTest.ACTION1)' target='\(FSMInjectorTest.TARGET1)' />" +
            "</state>" +
            "<state name='\(FSMInjectorTest.STATE2)' entering='\(FSMInjectorTest.ENTER2)'>" +
                "<transition action='\(FSMInjectorTest.ACTION2)' target='\(FSMInjectorTest.TARGET2)' />" +
            "</state>" +
            "<state name='\(FSMInjectorTest.STATE3)' entering='\(FSMInjectorTest.ENTER3)'>" +
                "<transition action='\(FSMInjectorTest.ACTION3)' target='\(FSMInjectorTest.TARGET3)' />" +
            "</state>" +
        "</fsm>"
        
        let injector = FSMInjector(fsm: fsm)
        injector.initializeNotifier("Key1")
        injector.inject()
        
        XCTAssertNotNil(injector, "Expecting inject not nil")
        XCTAssertNotNil(injector as FSMInjector, "Expecting injector as FSMInjector")
    }
    
    func testInvalidFSM() {
        let injector = FSMInjector(fsm: "")
        injector.initializeNotifier("Key1")
        injector.inject()
        
        XCTAssertNotNil(injector, "Expecting inject not nil")
        XCTAssertNotNil(injector as FSMInjector, "Expecting injector as FSMInjector")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
