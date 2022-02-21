Class {
	#name : #ODBCleanCodeTest,
	#superclass : #TestCase,
	#pools : [
		'ODBTypeCodes'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBCleanCodeTest >> testNoDuplicatedMethodInHierarchy [
	"There should be no methods in the hierachy that are already in a superclass"
	
	| methods |
	methods :=  OmniBase package methods reject: [:method | method isFromTrait].
	methods := methods select: [:method |
	method methodClass superclass
 		ifNotNil: [ :superclass | (superclass lookupSelector: method selector)
 			ifNotNil: [ :overridenMethod | method equivalentTo: overridenMethod ]
 			ifNil: [ false ] ]
 		ifNil: [ false ]].
		self 
		assert: methods isEmpty 
		description: ('the following methods are already in the superclass hierarchy and can be removed: ', methods asString)
]
