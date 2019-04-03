//
//  XMLParserDelegate.swift
//  PureMVC SWIFT MultiCore Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/// Protocol for a XMLParser Delegate.
public protocol FSMParserDelegate: class {
    
    /// Adopted by the FSMParser's Delegate object to be notified when it has successfully completed parsing.
    func onParse(_ stateList: [State]?, initial: String?)

}
