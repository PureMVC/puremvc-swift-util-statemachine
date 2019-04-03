//
//  FSMParserTest.swift
//  PureMVC SWIFT MultiCore Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
import StateMachine

class fsmParserTest: XCTestCase, FSMParserDelegate {

    private var initial: String?
    
    private var stateList: [State]?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructors() {
        let fsm = "<fsm></fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertNotNil(fsmParser, "Expecting fsmParser not nil")
        XCTAssertNotNil(fsmParser as FSMParser, "Expecting fsmParser as fsmParser")
        
        XCTAssertNil(initial, "Expecting initial to be nil")
        XCTAssertTrue(stateList!.isEmpty, "Expecting stateList to be empty")
    }
    
    func testInitial() {
        let fsm = "<fsm initial=''></fsm>"
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertNotNil(stateList, "Expecting stateList not nil")
        XCTAssertTrue(initial == "", "Expecting initial ''")
        XCTAssertNotNil(stateList, "Expecting stateList not nil")
        XCTAssertTrue(stateList?.count == 0, "Expecting stateList?.count == 0 to be true")
    }
    
    func testInitialAndState() {
        let fsm =
        "<fsm initial='initial_state'>" +
            "<state name='state11' />" +
        "</fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(initial == "initial_state", "Expecting initial == 'initial_state'")
        //XCTAssertNotNil(stateList!, "Expecting stateList not nil")
        XCTAssertTrue(stateList!.count == 1, "Expecting stateList!.count == 1")
        XCTAssertTrue(stateList![0].name == "state11", "Expecting stateList![0].name == 'state11'")
    }
    
    func testInvalidState() {
        let fsm =
        "<fsm>" +
            "<state />" +
        "</fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList!.isEmpty, "Expecting stateList!.isEmpty")
    }
    
    func testMultipleStates() {
        let fsm =
        "<fsm initial='initial_state'>" +
            "<state name='state11' />" +
            "<state name='state22' />" +
            "<state name='state33' />" +
        "</fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList!.count == 3, "Expecting stateList.count == 3")
        XCTAssertTrue(stateList![0].name == "state11", "Expecting stateList[0].name == 'state11'")
        XCTAssertTrue(stateList![1].name == "state22", "Expecting stateList[1].name == 'state22'")
        XCTAssertTrue(stateList![2].name == "state33", "Expecting stateList[2].name == 'state33'")
    }
    
    func testStateAttributes() {
        let fsm =
        "<fsm initial='initial_state'>" +
            "<state name='state11' entering='enter' />" +
            "<state name='state22' exiting='exit' />" +
            "<state name='state33' changed='change' />" +
        "</fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList!.count == 3, "Expecting stateList!.count == 3")
        
        XCTAssertTrue(stateList![0].name == "state11", "Expecting stateList![0].name == 'state11")
        XCTAssertTrue(stateList![0].entering == "enter", "Expecting stateList![0].enter == 'enter")
        XCTAssertTrue(stateList![0].exiting == nil, "Expecting stateList![0].exiting == nil")
        XCTAssertTrue(stateList![0].changed == nil, "Expecting stateList![0].changed == nil")
        
        XCTAssertTrue(stateList![1].name == "state22", "Expecting stateList![1].name == 'state22")
        XCTAssertTrue(stateList![1].entering == nil, "Expecting stateList![1].enter == nil")
        XCTAssertTrue(stateList![1].exiting == "exit", "Expecting stateList![1].exiting == 'exit'")
        XCTAssertTrue(stateList![1].changed == nil, "Expecting stateList![1].changed == nil")
        
        XCTAssertTrue(stateList![2].name == "state33", "Expecting stateList![2].name == 'state22")
        XCTAssertTrue(stateList![2].entering == nil, "Expecting stateList![1].enter == nil")
        XCTAssertTrue(stateList![2].exiting == nil, "Expecting stateList![1].exiting == nil")
        XCTAssertTrue(stateList![2].changed == "change", "Expecting stateList![1].changed == 'change'")
    }
    
    func testStateTransition() {
        let fsm =
        "<fsm initial='initial_state'>" +
            "<state name='state11'>" +
                "<transition action='action' target='target' />" +
                "<transition action='action2' target='target2' />" +
            "</state>" +
        "</fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList != nil, "Expecting stateList not to be nil")
        XCTAssertTrue(stateList!.count == 1, "Expecting stateList?.count == 1")
        XCTAssertTrue(stateList![0].getTarget("action") == "target", "Expecting stateList![0].getTarget('action') == 'target'")
        XCTAssertTrue(stateList![0].getTarget("action2") == "target2", "Expecting stateList![0].getTarget('action2') == 'target2'")
    }
    
    func testDuplicateTransition() {
        let fsm =
        "<fsm initial='initial_state'>" +
            "<state name='state11'>" +
                "<transition action='action' target='target' />" +
                "<transition action='action' target='target2' />" +
            "</state>" +
        "</fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList != nil, "Expecting stateList not to be nil")
        XCTAssertTrue(stateList!.count == 1, "Expecting stateList?.count == 1")
        XCTAssertTrue(stateList![0].getTarget("action") == "target", "Expecting stateList![0].getTarget('action') == 'target'")
    }
    
    func testInvalidXML() {
        var fsm = ""
        
        var fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList == nil, "stateList is nil")
        
        fsm = "12341234"
        fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList == nil, "stateList is nil")
    }
    
    func testStringInterpolation() {
        let state1 = "state1"
        let action1 = "action1"
        let target1 = "target1"
        
        let fsm =
        "<fsm>" +
            "<state name='\(state1)'>" +
                "<transition action='\(action1)' target='\(target1)' />" +
            "</state>" +
        "</fsm>"
        
        let fsmParser = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        
        XCTAssertTrue(stateList != nil, "Expecting stateList not to be nil")
        XCTAssertTrue(stateList!.count == 1, "Expecting stateList?.count == 1)")
        XCTAssertTrue(stateList![0].getTarget(action1) == target1, "Expecting stateList![0].getTarget('action') == 'target'")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func onStartDocument() {
        
    }
    
    func onParse(_ stateList: [State]?, initial: String?) {
        self.initial = initial
        self.stateList = stateList
    }

}
