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
public class FSMParser: NSObject, NSXMLParserDelegate {
    
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
        var data = fsm.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var parser = NSXMLParser(data: data!)
        parser.delegate = self
        parser.parse()
    }
    
    /// Creates a `State` instance from its XML definition.
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        switch elementName {
        case "fsm":
            stateList = []
            if let initial = attributeDict["initial"] as? String {
                self.initial = initial
            }
        // Create State object
        case "state":
            if let name = attributeDict["name"] as? String {
                var entering = attributeDict["entering"] as? String
                var exiting = attributeDict["exiting"] as? String
                var changed = attributeDict["changed"] as? String
                
                stateList?.append(State(name: name, entering: entering, exiting: exiting, changed: changed))
            }
        // Create transitions
        case "transition":
            stateList![stateList!.count-1].defineTrans(attributeDict["action"] as! String, target: attributeDict["target"] as! String)
        default:
            break
        }
    }

    /// Called by the parser object when it has successfully completed parsing.
    public func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.onParse(stateList, initial: initial)
    }

}
