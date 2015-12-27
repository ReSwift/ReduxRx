//
//  ReduxRxDisposable.swift
//  ReduxKitRxSwift
//
//  Created by Karl Bowden on 27/12/2015.
//  Copyright © 2015 Redux. All rights reserved.
//

import RxSwift
import ReduxKit

/**
 Simple implementation of ReduxDisposable to wrap RxSwift.Disposable types.

 - note: RxSwift.Disposable does not have a `disposed` parameter that can be
         exposed. Hence the disposed parameter always returns false.
 */
public struct ReduxRxDisposable: ReduxDisposable {

    /// Fallback implementation. Always returns `false`
    public let disposed: Bool = false

    /// Cancels the observation and disposes of the connection
    public let dispose: () -> ()

    /**
     Create a ReduxDisposable from an RxSwift.Disposable

     - parameter disposable: RxSwift.Disposable
     */
    public init(disposable: Disposable) {
        dispose = disposable.dispose
    }
}
