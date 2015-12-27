//
//  createStore.swift
//  ReduxKitRxSwift
//
//  Created by Karl Bowden on 27/12/2015.
//  Copyright © 2015 Redux. All rights reserved.
//

import RxSwift
import ReduxKit

/**
 Create a ReduxKit Store backed by an RxSwift PublishSubject and ReplaySubject.

 - parameter reducer: ReduxKit reducer
 - parameter state:   Optional initial state

 - returns: Store<State>
 */
public func createStore<State>(
    reducer: ((State?, ReduxKit.Action) -> State),
    state: State? = nil)
    -> Store<State> {

        typealias StoreCreator = (
            reducer: ((State?, ReduxKit.Action) -> State),
            state: State?)
            -> Store<State>

        let backing: (
            publisher: PublishSubject<Action>,
            subject: ReplaySubject<State>,
            createStore: StoreCreator) = setupStoreBacking()

        return backing.createStore(reducer: reducer, state: state)
}
