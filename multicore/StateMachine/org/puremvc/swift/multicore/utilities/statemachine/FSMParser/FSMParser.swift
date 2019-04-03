//
//  XMLParser.swift
//  PureMVC SWIFT MultiCore Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

/**
A parser for the Finite State Machine XML representation.
*/
public class FSMParser: NSObject, XMLParserDelegate {
    
    // The XML FSM definition
    private var fsm: String
    
    /// delegate for notification on end of the document
    weak public var delegate: FSMParserDelegate?
    
    // The name of the initial state
    private var initial: String?
    
    // The List of State objects
    private var stateList: [State]?
    
    /// Constructor.
    public init(fsm: String) {
        self.fsm = fsm
    }
    
    /// Start the xml parsing process
    public func parse() {
        let data = fsm.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let parser = XMLParser(data: data!)
        parser.delegate = self
        parser.parse()
    }
    
    /// Creates a `State` instance from its XML definition.
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
        case "fsm":
            stateList = []
            if let initial = attributeDict["initial"] {
                self.initial = initial
            }
        // Create State object
        case "state":
            if let name = attributeDict["name"] {
                let entering = attributeDict["entering"]
                let exiting = attributeDict["exiting"]
                let changed = attributeDict["changed"]
                
                stateList?.append(State(name: name, entering: entering, exiting: exiting, changed: changed))
            }
        // Create transitions
        case "transition":
            if let action = attributeDict["action"], let target = attributeDict["target"] {
                stateList![stateList!.count-1].defineTrans(action, target: target)
            }
        default:
            break
        }
    }

    /// Called by the parser object when it has successfully completed parsing.
    public func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.onParse(stateList, initial: initial)
    }

}
