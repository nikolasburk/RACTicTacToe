### Actions

`Action<Input, Output, Error: ErrorType>`:

Represents an action that will do some work when executed with a value of type `Input`, then return zero or more values of type `Output` and/or fail with an error of type `Error`. If no failure should be possible, NoError can be specified for the `Error` parameter.

To initialize an action, you need to pass the `execute` function from `Input` to `SignalProducer<Output, Error>`.

     func execute: Input -> SignalProducer<Output, Error>

This gets stored as a _property_ of the instance called `executeClosure`. 

For example, the following code creates an `Action<String, String, NoError>`:

    let action = Action { s in // s is of the Output type
        return SignalProducer { sink, _ in
            sink.sendNext("send next...") // the argument passed to sendNext needs to be of the Output type of the action
            sink.sendCompleted()
        }
    }

`CocoaAction` -> Initializes a Cocoa action that will invoke the given Action by transforming the object given to `execute()`.

`public init<Input, Output, Error>(_ action: ReactiveCocoa.Action<Input, Output, Error>, _ inputTransform: AnyObject? -> Input)`

The above `action` can be wrapped into a `CocoaAction` like so:

    startButtonAction = CocoaAction(action) { x in
            if let button = x {
                if let title = button.titleLabel!!.text {
                    print("the button with title ---\(title)--- was pressed")
                }
            }
            return "where am I???"
    }

Here `inputTransform: AnyObject? -> Input` takes the input of type `UIButton` which is the button that triggers the action. The return value of this function is of type `Input` (_not_ `Output`) and


### `Signal` vs. `SignalProducer`

Signal producers are used to represents operations or tasks, where the act of starting the signal producer initiates the operation. Whereas signals represents a stream of events which occur regardless of whether observers have been added or not. Signal producers are a good fit for network requests, whereas signals work well for streams of UI events. [Colin Eberhardt](http://blog.scottlogic.com/2015/04/28/reactive-cocoa-3-continued.html)


### Property bindings:

Binds a signal to a property, updating the property's value to the latest value sent by the signal.
The binding will automatically terminate when the property is deinitialized, or when the signal sends a `Completed` event.

`public func <~<P : MutablePropertyType>(property: P, signal: ReactiveCocoa.Signal<P.Value, ReactiveCocoa.NoError>) -> Disposable`


Creates a signal from the given producer, which will be immediately bound to the given property, updating the property's value to the latest value sent by the signal.
The binding will automatically terminate when the property is deinitialized, or when the created signal sends a `Completed` event.

`public func <~<P : MutablePropertyType>(property: P, producer: ReactiveCocoa.SignalProducer<P.Value, ReactiveCocoa.NoError>) -> Disposable`


Binds `destinationProperty` to the latest values of `sourceProperty`. The binding will automatically terminate when either property is deinitialized.

`public func <~<Destination : MutablePropertyType, Source : PropertyType where Source.Value == Destination.Value>(destinationProperty: Destination, sourceProperty: Source) -> Disposable`
