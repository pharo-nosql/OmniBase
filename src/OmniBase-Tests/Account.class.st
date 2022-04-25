Class {
	#name : #Account,
	#superclass : #Object,
	#instVars : [
		'balance'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #accessing }
Account >> balance [

	^ balance
]

{ #category : #accessing }
Account >> balance: anInteger [ 
	balance := anInteger
]

{ #category : #accessing }
Account >> decrement: anInteger [ 
	balance := balance - anInteger
]

{ #category : #accessing }
Account >> increment: anInteger [ 
	balance := balance + anInteger
]

{ #category : #transferring }
Account >> transfer: anInteger to: anAccount [ 
	self decrement: anInteger.
	anAccount increment: anInteger.
]
