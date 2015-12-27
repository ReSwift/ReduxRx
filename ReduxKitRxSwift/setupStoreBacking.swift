//
//  setupStoreBacking.swift
//  ReduxKitRxSwift
//
//  Created by Karl Bowden on 27/12/2015.
//  Copyright © 2015 Redux. All rights reserved.
//

import RxSwift
import ReduxKit

/**
 Sets up a createStore function to create a ReduxKit.Store<State> using an
 RxSwift PublishSubject and ReplaySubject.

 __publisher__: `RxSwift.PublishSubject<Action>`
 - Reduces and action and publishes it to the stateSubject

 __subject__: `RxSwift.ReplaySubject<State>`
 - A subscribable hot signal of resulting states

 __createStore__: `(Reducer, State?) -> Store<State>`
 - the createStore function to be used when creating a ReduxKit Store

 - returns: (
    RxSwift.PublishSubject,
    RxSwift.ReplaySubject,
    StoreCreator(reducer, state) -> Store<State>)
*/
public func setupStoreBacking<State>() -> (
    publisher: PublishSubject<Action>,
    subject: ReplaySubject<State>,
    createStore: (reducer: ((State?, ReduxKit.Action) -> State), state: State?) -> Store<State>) {

    typealias Subscriber = State -> ()

    let subjectDispatcher: PublishSubject<Action> = PublishSubject()
    let stateSubject = ReplaySubject<State>.create(bufferSize: 1)

    return (subjectDispatcher, stateSubject, { reducer, state in

        let initalState = state ?? reducer(state, DefaultAction())

        // have the stateSubject subscribe to the dispatcher
        subjectDispatcher
            .scan(initalState, accumulator: reducer)
            .startWith(initalState)
            .subscribe(stateSubject)

        return Store(subjectDispatcher: subjectDispatcher, stateSubject: stateSubject)
    })
}
