//
//  FSMInjector.swift
//  PureMVC SWIFT MultiCore Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

/**
Creates and registers a StateMachine described in XML.

This allows reconfiguration of the StateMachine
without changing any code, as well as making it
easier than creating all the `State`
instances and registering them with the
`StateMachine` at startup time.

`@see State`

`@see StateMachine`
*/
public class FSMInjector: Notifier, FSMParserDelegate {
    
    // The XML FSM definition
    private var fsm: String
    
    // The name of the initial state
    private var initial: String?
    
    // The List of State objects
    private var stateList: [State]?
    
    /// Constructor.
    public init(fsm: String) {
        self.fsm = fsm
    }
    
    /**
    Inject the `StateMachine` into the PureMVC apparatus.
    
    Creates the `StateMachine` instance, registers all the states
    and registers the `StateMachine` with the `IFacade`.
    */
    public func inject() {
        // Create the StateMachine
        let stateMachine = StateMachine()
        
        // parse the FSM XML
        var fsmParser: FSMParser! = FSMParser(fsm: fsm)
        fsmParser.delegate = self
        fsmParser.parse()
        fsmParser = nil
        
        // Register all the states with the StateMachine
        if let states = stateList {
            for state in states {
                stateMachine.registerState(state, initial: isInitial(state.name))
            }
        }
        
        // Register the StateMachine with the facade
        facade.registerMediator(stateMachine)
    }

    /// Called by the FSMParser object when it has successfully completed parsing.
    public func onParse(stateList: [State]?, initial: String?) {
        self.stateList = stateList
        self.initial = initial
    }
    
    /// Is the given state the initial state?
    private func isInitial(stateName: String) -> Bool {
        return stateName == initial
    }
    
}

