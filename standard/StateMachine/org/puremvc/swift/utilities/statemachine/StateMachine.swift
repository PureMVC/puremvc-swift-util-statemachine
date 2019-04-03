//
//  StateMachine.swift
//  PureMVC SWIFT Standard Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

/**
A Finite State Machine implimentation.

Handles regisistration and removal of state definitions,
which include optional entry and exit commands for each
state.
*/
public class StateMachine: Mediator {
    
    /// Name of the State Machine Mediator
    public override class var NAME: String { return "StateMachine" }
    
    /// Action Notification name.
    public class var ACTION: String { return "action" }
    
    /// Changed Notification name
    public class var CHANGED: String { return "changed" }
    
    /// Cancel Notification name
    public class var CANCEL: String { return "cancel" }

    /// Map of States objects by name.
    private var states = [String: State]()
    
    /// The initial state of the FSM.
    private var initial: State?
    
    /// The transition has been canceled.
    private var canceled: Bool?
    
    /// Constructor.
    public init() {
        super.init(mediatorName: StateMachine.NAME)
    }
    
    /// Transition to a default state if defined once `StateMachine` is registered with `Facade`
    public override func onRegister() {
        if let initial = initial {
            transitionTo(initial, data: nil)
        }
    }
    
    /**
    Registers the entry and exit commands for a given state.
    
    - parameter state: the state to which to register the above commands
    - parameter initial: boolean telling if this is the initial state of the system
    */
    public func registerState(_ state: State, initial: Bool = false) -> Bool {
        if states[state.name] != nil { return false }
        states[state.name] = state
        if initial == true {
            self.initial = state
        }
        return true
    }
    
    /**
    Remove a state mapping.
    
    Removes the entry and exit commands for a given state
    as well as the state mapping itself.
    
    - parameter state:
    */
    public func removeState(_ stateName: String) -> State? {
        if let state = states[stateName] {
            states[stateName] = nil
            return state
        }
        return nil
    }
    
    /**
    Transitions to the given state from the current state.
    
    Sends the `exiting` notification for the current state
    followed by the `entering` notification for the new state.
    Once finally transitioned to the new state, the `changed`
    notification for the new state is sent.
    
    If a data parameter is provided, it is included as the body of all
    three state-specific transition notes.
    
    Finally, when all the state-specific transition notes have been
    sent, a `StateMachine.CHANGED` note is sent, with the
    new `State` object as the `body` and the name of the
    new state in the `type`.
    
    - parameter nextState: the next State to transition to.
    - parameter data: is the optional Object that was sent in the `StateMachine.ACTION` notification body
    */
    private func transitionTo(_ nextState: State, data: Any?) {
        
        // Clear the cancel flag
        canceled = false
        
        // Exit the current State
        if currentState?.exiting != nil {
            sendNotification(currentState!.exiting!, body: nextState.name)
        }
        
        // Check to see whether the exiting guard has canceled the transition
        if let canceled = canceled, canceled == true {
            self.canceled = false
            return
        }
        
        // Enter the next State
        if nextState.entering != nil {
            sendNotification(nextState.entering!, body: data)
        }
        
        // Check to see whether the entering guard has canceled the transition
        if let canceled = canceled, canceled == true {
            self.canceled = false
            return
        }
        
        // change the current state only when both guards have been passed
        currentState = nextState
        
        // Send the notification configured to be sent when this specific state becomes current
        if nextState.changed != nil {
            sendNotification(currentState!.changed!, body: data)
        }
        
        // Notify the app generally that the state changed and what the new state is
        sendNotification(StateMachine.CHANGED, body: currentState!.name)
    }
    
    /// Notification interests for the StateMachine.
    public override func listNotificationInterests() -> [String] {
        return [
            StateMachine.ACTION,
            StateMachine.CANCEL
        ]
    }
    
    /**
    Handle notifications the `StateMachine` is interested in.
    
    `StateMachine.ACTION`: Triggers the transition to a new state.
    
    `StateMachine.CANCEL`: Cancels the transition if sent in response to the exiting note for the current state.
    */
    public override func handleNotification(_ notification: INotification) {
        switch notification.name {
        case StateMachine.ACTION:
            if let action = notification.type {
                if let target = currentState?.getTarget(action) {
                    if let newState = states[target] {
                        transitionTo(newState, data: notification.body)
                    }
                }
            }
        case StateMachine.CANCEL:
            canceled = true
        default:
            return
        }
    }
    
    /// Get or set the current state.
    public var currentState: State? {
        get { return viewComponent as? State }
        set { viewComponent = newValue }
    }
    
}
