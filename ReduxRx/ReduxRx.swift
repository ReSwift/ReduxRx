//
//  ReduxRx.swift
//  ReduxRx
//
//  Created by Karl Bowden on 20/12/2015.
//  Copyright © 2015 SwiftRedux. All rights reserved.
//

import RxSwift
import Redux

/**

 Uses `createStateStream` to create a `Redux.Store<State>` using an
 `RxSwift.Variable<State>` stream.

 */
public func createStore<State>(
    reducer: ((State?, Redux.Action) -> State),
    state: State? = nil)
    -> Store<State> {

        return createStreamStore(createStream, reducer: reducer, state: state)
}

/**

 Accepts a `State` and returns `Redux.StateStream<State>` using an
 `RxSwift.Variable<State>` as the stream provider.

 */
public func createStream<State>(state: State) -> StateStream<State> {

    typealias Subscriber = State -> ()
    typealias Dispatcher = State -> ()

    let variable = Variable(state)

    let dispatch: Dispatcher = { state in
        variable.value = state
    }

    let subscribe: (Subscriber) -> ReduxDisposable = { subscriber in
        return createDisposable(variable.subscribeNext(subscriber))
    }

    let getState: () -> State = {
        return variable.value
    }

    return StateStream(dispatch: dispatch, subscribe: subscribe, getState: getState)
}

/**

 Accepts an `RxSwift.Disposable` and returns it wrapped as a `ReduxDisposable`.

 The returned disposable only supports the `disposable.dispose()` function and
 does not return disposed state (`disposable.disposed` always returns `false`).

 */
public func createDisposable(disposable: RxSwift.Disposable) -> ReduxDisposable {

    return SimpleReduxDisposable(disposed: { false }, dispose: disposable.dispose)
}
