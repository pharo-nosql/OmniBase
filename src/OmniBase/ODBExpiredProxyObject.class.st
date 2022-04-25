Class {
	#name : #ODBExpiredProxyObject,
	#superclass : #ProtoObject,
	#instVars : [
		'oid'
	],
	#category : #'OmniBase-Transaction'
}

{ #category : #public }
ODBExpiredProxyObject class >> on: oid [ 
	^self new oid: oid
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
	"This is the typical message to use for inserting breakpoints during debugging."
	<debuggerCompleteToSender>
	<ignoreForCoverage>
	Halt now
]

{ #category : #public }
ODBExpiredProxyObject >> inspect [
	"Create and schedule an Inspector in which the user can examine the receiver's variables."
	<ignoreForCoverage>
	^ Smalltalk tools inspector inspect: self
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
