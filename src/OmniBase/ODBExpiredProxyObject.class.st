Class {
	#name : #ODBExpiredProxyObject,
	#superclass : #ProtoObject,
	#instVars : [
		'oid'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBExpiredProxyObject class >> on: oid [ 
	^self new oid: oid
]

{ #category : #public }
ODBExpiredProxyObject >> == anObject [
	"Answer true if the receiver and the argument are the same object (have the same
	object pointer) and false otherwise.  Do not redefine the message == in any
	other class!  No Lookup."

	<primitive: 110>
	self primitiveFailed
]

{ #category : #public }
ODBExpiredProxyObject >> becomeForward: otherObject [ 
	"Primitive. All variables in the entire system that used to point
	to the receiver now point to the argument.
	Fails if either argument is a SmallInteger."

	(Array with: self)
		elementsForwardIdentityTo:
			(Array with: otherObject)
]

{ #category : #public }
ODBExpiredProxyObject >> defaultLabelForInspector [
	"Answer the default label to be used for an Inspector window on the receiver."

	^ self class name
]

{ #category : #public }
ODBExpiredProxyObject >> doesNotUnderstand: aMessage [
	
	| currentTransaction freshTarget |

	[currentTransaction := OmniBase currentTransaction] 
		on: ODBNoActiveTransaction
		do:[:x| ODBMessageSentToAnExpiredObject signal].
		
	^ currentTransaction isAborted
		ifTrue: [ODBMessageSentToAnExpiredObject signal]
		ifFalse:[ 
			freshTarget := currentTransaction objectAt: oid.
			self becomeForward: freshTarget.
			freshTarget 
				perform: aMessage selector
				withArguments: aMessage arguments]. 

]

{ #category : #public }
ODBExpiredProxyObject >> halt [
	"This is the typical message to use for inserting breakpoints during 
	debugging. It behaves like halt:, but does not call on halt: in order to 
	avoid putting this message on the stack. Halt is especially useful when 
	the breakpoint message is an arbitrary one."

	Halt signal
]

{ #category : #public }
ODBExpiredProxyObject >> inspect [
	"Create and schedule an Inspector in which the user can examine the receiver's variables."
	Smalltalk tools inspect: self
]

{ #category : #public }
ODBExpiredProxyObject >> inspectorClass [
	"Answer the class of the inspector to be used on the receiver.  Called by inspect; 
	use basicInspect to get a normal (less useful) type of inspector."

	^ Smalltalk tools inspector
]

{ #category : #public }
ODBExpiredProxyObject >> isIdenticalTo: anObject [ 
	"Answer true if anObject is identical to receiver. This is necessary since with database
	proxies the real object identity is lost because while the object is not yet loaded from the
	database it is represented by its proxy. Later when the real object is loaded this proxy still
	represents the identical object but the #== identity check will answer false because it is not
	aware of this. It is implemented in this way because the #== method is inlined and can not
	be overridden."

	^ oid = anObject odbObjectID
]

{ #category : #public }
ODBExpiredProxyObject >> isImmediate [
	"Private - Answer whether the receiver has an immediate representation (that is it is entirely
	encoded in an object pointer, e.g. SmallIntegers. Most objects are not immediate."

	^false
]

{ #category : #public }
ODBExpiredProxyObject >> isODBExpired [

	^ true
]

{ #category : #public }
ODBExpiredProxyObject >> isODBPersistent [

	^ true
]

{ #category : #public }
ODBExpiredProxyObject >> odbBasicSerialize: serializer [ 
	OmniBase 
		signalError: 'This object can not be serialized. The transaction in which this proxy was loaded is already aborted.'
]

{ #category : #public }
ODBExpiredProxyObject >> odbSerialize: serializer [ 
	OmniBase 
		signalError: 'This object can not be serialized. The transaction in which this proxy was loaded is already aborted.'
]

{ #category : #public }
ODBExpiredProxyObject >> oid: anODBObjectID [ 
	oid := anODBObjectID
]

{ #category : #public }
ODBExpiredProxyObject >> printOn: aStream [ 
	aStream nextPutAll: 'Expired OmniBase proxy object of OID='.
	oid printOn: aStream
]

{ #category : #public }
ODBExpiredProxyObject >> value [ 

	^ self
]
