//
//  Store+init.swift
//  ReduxKitRxSwift
//
//  Created by Karl Bowden on 27/12/2015.
//  Copyright © 2015 Redux. All rights reserved.
//

import RxSwift
import ReduxKit

extension Store {

    /**
     Initialise a ReduxKit Store from an RxSwift PublishSubject and ReplayAction

     - parameter subjectDispatcher: RxSwift.PublishSubject<Action>
     - parameter stateSubject:      ReplaySubject<State>
     */
    public init(subjectDispatcher: PublishSubject<Action>, stateSubject: ReplaySubject<State>) {

        dispatch = { action in
            subjectDispatcher.onNext(action)
            return action
        }

        subscribe = { subscriber in
            return ReduxRxDisposable(disposable: stateSubject.subscribeNext(subscriber))
        }

        getState = {
            var state: State!
            stateSubject.take(1).subscribeNext { state = $0 }.dispose()
            return state
        }
    }
}
