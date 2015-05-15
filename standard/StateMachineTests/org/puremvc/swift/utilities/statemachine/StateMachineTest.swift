//
//  StateMachineTest.swift
//  PureMVC SWIFT Standard Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import StateMachine
import XCTest
import PureMVC

class StateMachineTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructors() {
        var stateMachine = StateMachine()
        
        XCTAssertNotNil(stateMachine, "Expecting stateMachine to be defined")
        XCTAssertNotNil(stateMachine as StateMachine, "Expecting stateMachine to be instance of StateMachine")
    }
    
    func testRegisterState() {
        var stateMachine = StateMachine()
        var state1 = State(name: "state1")
        var registered = stateMachine.registerState(state1)
        
        XCTAssertTrue(registered, "Expecting state1 was registered")
        
        var registeredAgain = stateMachine.registerState(state1)
        XCTAssertTrue(registeredAgain == false, "Expecting re-registration to return false")
        
    }
    
    func testremoveState() {
        var stateMachine = StateMachine()
        var state1 = State(name: "state1")
        stateMachine.registerState(state1)
        
        var removedState = stateMachine.removeState("state1")
        XCTAssertTrue(removedState === state1, "Expecting removedState === state1")
        
        stateMachine.removeState("state1")
    }
    
    func testGetCurrentState() {
        var stateMachine = StateMachine()
        
        XCTAssertNil(stateMachine.currentState, "Expecting current state to be nil")
        var state1 = State(name: "state1")
        stateMachine.currentState = state1
        
        var currentState = stateMachine.currentState
        XCTAssertNotNil(currentState, "Expecting currentState to be defined")
        XCTAssertTrue(currentState === state1, "Expecgin currentState === state1")
    }
    
    func testTransitionTo() {
        var stateMachine = StateMachine()
        var state1 = State(name: "state1")
        var facade: Facade = Facade.getInstance() {Facade()} as! Facade
        
        stateMachine.registerState(state1, initial: true)
        //XCTAssertTrue(stateMachine.currentState === state1, "Expecting currentState to be state1")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
