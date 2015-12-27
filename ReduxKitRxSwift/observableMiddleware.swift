//
//  observableMiddleware.swift
//  ReduxKitRxSwift
//
//  Created by Karl Bowden on 23/12/2015.
//  Copyright © 2015 Redux. All rights reserved.
//

import ReduxKit

/**
 ReduxKit middleware that dispatches the result of an ObservableAction payload.

 The success and failure states of the ObservableAction are connected to dispatch.

 - parameter store: Store supplied by the StoreEnhancer

 - returns: Dispatch transformer middleware
*/
public func observableMiddleware<State>(store: Store<State>) -> DispatchTransformer {
    return { next in { action in
        guard let originalAction = action as? ObservableAction else { return next(action) }

        let observable = originalAction.rawPayload
            .doOn(
                onNext: { successAction in
                    store.dispatch(successAction)
                },
                onError: { error in
                    guard let errorAction = error as? Action else { return }
                    store.dispatch(errorAction)
            })

        let newAction = originalAction.replacePayload(observable)

        return next(newAction)
        }
    }
}
