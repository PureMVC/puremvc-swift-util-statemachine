//
//  State.swift
//  PureMVC SWIFT MultiCore Utility – StateMachine
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
Defines a State.
*/
public class State {
    
    /// The state name
    public var name: String
    
    /// The notification to dispatch when entering the state
    public var entering: String?
    
    /// The notification to dispatch when exiting the state
    public var exiting: String?
    
    /// The notification to dispatch when the state has actually changed
    public var changed: String?
    
    /// Transition map of actions to target states
    private var transitions = [String: String]()
    
    /**
    Constructor.
    
    - parameter id: the id of the state
    - parameter entering: an optional notification name to be sent when entering this state
    - parameter exiting: an optional notification name to be sent when exiting this state
    - parameter changed: an optional notification name to be sent when fully transitioned to this state
    */
    public init(name: String, entering: String?=nil, exiting: String?=nil, changed: String?=nil) {
        self.name = name
        if entering != nil { self.entering = entering }
        if exiting != nil { self.exiting = exiting }
        if changed != nil { self.changed = changed }
    }
    
    /**
    Define a transition.
    
    - parameter action: the name of the StateMachine.ACTION Notification type.
    - parameter target: the name of the target state to transition to.
    */
    public func defineTrans(action: String, target: String) {
        if getTarget(action) == nil {
            transitions[action] = target
        }
    }
    
    /**
    Remove a previously defined transition.
    
    - returns: the name of the target associated with the action
    */
    public func removeTrans(action: String) -> String? {
        if let target = transitions[action] {
            transitions[action] = nil
            return target
        }
        return nil
    }
    
    /// Get the target state name for a given action.
    public func getTarget(action: String) -> String? {
        return transitions[action]
    }
    
}