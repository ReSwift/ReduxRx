//
//  ObservableAction.swift
//  ReduxKitRxSwift
//
//  Created by Karl Bowden on 23/12/2015.
//  Copyright © 2015 Redux. All rights reserved.
//

import ReduxKit
import RxSwift

/**
 ObservableActions take a payload type that executes once observed then
 dispatches the result if successful.
 */
public protocol ObservableAction: Action {

    var rawPayload: Observable<Action> { get set }

    /**
     Immutabily modify the payload of an ObservableAction

     - parameter payload: New payload

     - returns: Returns a copy of the current ObservableAction with the
                existing payload replaced with the supplied payload
     */
    func replacePayload(payload: Observable<Action>) -> Self
}

public extension ObservableAction {

    /// Default implementation of the standard action payload and type
    public var payload: Any? { return rawPayload }
}

public protocol ObservableActionError: SimpleStandardAction, ErrorType {}

public extension ObservableActionError {

    public var error: Bool { return true }
}
