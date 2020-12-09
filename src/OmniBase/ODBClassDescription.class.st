Class {
	#name : #ODBClassDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'bytes',
		'variable',
		'instSize',
		'instVarNames',
		'instVarIndexes',
		'class',
		'varOrder',
		'classID'
	],
	#category : 'OmniBase'
}

{ #category : #private }
ODBClassDescription >> allPersistentInstanceVariablesFor: aClass [ 
	^(aClass allInstVarNames 
		reject: [:each | aClass odbTransientInstanceVariables includes: each]) asArray
]

{ #category : #public }
ODBClassDescription >> classID [

	^classID
]

{ #category : #public }
ODBClassDescription >> classID: anInteger [

	classID := anInteger.
]

{ #category : #public }
ODBClassDescription >> createFor: aClass [

	class := aClass.
	name := aClass name.
	instVarNames := self allPersistentInstanceVariablesFor: aClass.
	instSize := instVarNames size.
	bytes := aClass isBits.
	variable := aClass isVariable.
	self updateVariableOrder
]

{ #category : #public }
ODBClassDescription >> createdFor: aClass [

	^name = aClass name asString
		and: [ variable = aClass isVariable
		and: [ bytes = aClass isBits
		and: [ instVarNames = (self allPersistentInstanceVariablesFor: aClass) ]]]
]

{ #category : #public }
ODBClassDescription >> instSize [

	^instSize
]

{ #category : #public }
ODBClassDescription >> instVarIndexes [

	^instVarIndexes
]

{ #category : #public }
ODBClassDescription >> instVarNames [

	^instVarNames
]

{ #category : #public }
ODBClassDescription >> isBytes [

	^bytes
]

{ #category : #public }
ODBClassDescription >> isVariable [

	^variable
]

{ #category : #public }
ODBClassDescription >> loadFromStream: aStream [

	name := aStream getString.
	bytes := aStream getBoolean.
	variable := aStream getBoolean.
	instSize := aStream getPositiveInteger.
	instVarNames := Array new: instSize.
	1 to: instSize do: [:i | instVarNames at: i put: aStream getString].
	self updateVariableOrder.
]

{ #category : #public }
ODBClassDescription >> name [

	^name
]

{ #category : #public }
ODBClassDescription >> realClass [

	^class
]

{ #category : #public }
ODBClassDescription >> realInstSize [

	^class instSize
]

{ #category : #public }
ODBClassDescription >> saveOnStream: aStream [ 
	aStream
		putString: name;
		putBoolean: bytes;
		putBoolean: variable;
		putPositiveInteger: instSize.
	instVarNames do: [:n | aStream putString: n]
]

{ #category : #private }
ODBClassDescription >> updateVariableOrder [
	| realNames |
	class := Smalltalk at: name asSymbol ifAbsent: [].
	varOrder := Array new: instVarNames size.
	class isNil 
		ifTrue: [varOrder atAllPut: 1]
		ifFalse: 
			[realNames := class allInstVarNames.
			1 to: varOrder size
				do: 
					[:i | 
					(varOrder at: i put: (realNames indexOf: (instVarNames at: i))) = 0 
						ifTrue: [varOrder at: i put: realNames size + 1]].
			instVarIndexes := Array new: instVarNames size.
			1 to: instVarNames size
				do: [:i | instVarIndexes at: i put: (class allInstVarNames indexOf: (instVarNames at: i))]]
]

{ #category : #public }
ODBClassDescription >> variableOrder [
	^varOrder
]
