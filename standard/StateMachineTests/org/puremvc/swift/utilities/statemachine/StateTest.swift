//
//  StateTest.swift
//  PureMVC SWIFT Standard Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

//import PureMVC
import StateMachine
import XCTest

class StateTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructors() {
        var state = State(name: "state1")
        
        XCTAssertNotNil(state, "Expecting state to be defined")
        XCTAssertNotNil(state as State, "Expecting state to be instance of State")
        XCTAssertEqual(state.name, "state1", "Expecting state.name to be 'state1'")
        XCTAssertNil(state.entering, "Expecting state.entering to be nil")
        XCTAssertNil(state.exiting, "Expecting state.exiting to be nil")
        XCTAssertNil(state.changed, "Expecting state.changed to be nil")

        state = State(name: "state1", entering: "entering", exiting: "exiting", changed: "changed")
        XCTAssertNotNil(state, "Expecting state not nil")
        XCTAssertNotNil(state as State, "Expecting state to be instance of State")
        XCTAssertEqual(state.name, "state1", "Expecting state.name to be 'state1'")
        XCTAssertEqual(state.entering!, "entering", "Expecting state.entering to be 'entering'")
        XCTAssertEqual(state.exiting!, "exiting", "Expecting state.exiting to be 'exiting'")
        XCTAssertEqual(state.changed!, "changed", "Expecting state.changed to be 'changed'")
    }
    
    func testDefineTrans() {
        var state = State(name: "state1")
        state.defineTrans("action", target: "target")
        XCTAssertEqual(state.getTarget("action")!, "target", "Expecting state.getTarget('action') to be 'target'")
        
        //redefining same action and check still registered
        state.defineTrans("action", target: "target")
        XCTAssertEqual(state.getTarget("action")!, "target", "Expecting state.getTarget('action') to be 'target'")
        
        //redefining with same action but another target will presist the old value
        state.defineTrans("action", target: "target2")
        XCTAssertNotEqual(state.getTarget("action")!, "target2", "Expecting state.getTarget('action') not to be 'target2'")
    }
    
    func testRemoveTrans() {
        var state = State(name: "state1")
        state.defineTrans("action", target: "target")
        XCTAssertEqual(state.getTarget("action")!, "target", "Expecting state.getTarget('action') to be 'target'")
        
        var removedTarget = state.removeTrans("action")
        XCTAssertNil(state.getTarget("action"), "Expecting state.getTarget('action') to be nil")
        XCTAssertTrue(removedTarget == "target", "Expecting removedTarget == 'target")
        
        state.removeTrans("action")
        XCTAssertNil(state.getTarget("action"), "Expecting removal not to crash")
    }
    
    func testGetTarget() {
        var state = State(name: "state1")
        state.defineTrans("action", target: "target")
        var target = state.getTarget("action")
        XCTAssertEqual(target!, "target", "Expecting target to be 'target'")
        
        target = state.getTarget("action1")
        XCTAssertNil(target, "Expecting defined target to be nil")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
