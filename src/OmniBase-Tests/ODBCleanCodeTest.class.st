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

{ #category : #tests }
ODBCleanCodeTest >> testNoUncategorizedMethods [
	"Check that we have no #'as yet unclassified' protocols left"

	| violating classes |
	classes := OmniBase package definedClasses
	           , OmniBase package definedClasses collect: [ :each | each classSide ].

	violating := classes select: [ :class | 
		             class protocols includes: #'as yet unclassified' ].
	self
		assert: violating isEmpty
		description: 'the following classes have uncategorized methods: ', violating asString
]

{ #category : #tests }
ODBCleanCodeTest >> testNoUnimplementedCalls [

	| remaining |
	remaining := OmniBase package methods select: [ :meth | 
		             | ignored |
		             ignored := (meth pragmaAt: #ignoreUnimplementedCalls:)
			                        ifNotNil: [ :pragma | pragma argumentAt: 1 ]
			                        ifNil: [ #(  ) ].
		             meth messages anySatisfy: [ :m | 
			             m isSelectorSymbol not and: [ 
				             (ignored includes: m) not ] ] ].
	
	self assert: remaining isEmpty description: ('the following methods send selectors that do not exist', remaining asString)
	

]

{ #category : #tests }
ODBCleanCodeTest >> testNoUnusedInstanceVariablesLeft [
	| variables classes validExceptions remaining |
	
	variables := OmniBase package definedClasses flatCollect: [ :each | each instanceVariables ].
	variables := variables reject: [ :each | each isReferenced ].
	
	classes := variables collect: [ :each | each definingClass ] as: Set.
	
	validExceptions := { }.	
	
	remaining := classes asOrderedCollection removeAll: validExceptions; yourself.
	self assert: remaining isEmpty description: ('the following classes have unused instance variables and should be cleaned: ', remaining asString)
]

{ #category : #tests }
ODBCleanCodeTest >> testNoUnusedTemporaryVariablesLeft [
	"Fail if there are methods who have unused temporary variables"
	| found  |
	found := OmniBase package methods select: [ :m |
		"before creating the AST (slow), check if there are temps" 
		((m numTemps - m numArgs) > 0) and: [  
		m ast temporaries anySatisfy: [ :x | x binding isUsed not] ] ].
							
	self 
		assert: found isEmpty 
		description: ('the following methods have unused temporary variables and should be cleaned: ', found asString)
]
