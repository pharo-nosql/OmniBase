Class {
	#name : #ODBClassDescriptionTest,
	#superclass : #OmniBaseTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBClassDescriptionTest >> testReshape [

	| tmpClass desc1 desc2 |
	tmpClass := ODBTestClass1 copy.
	desc1 := ODBClassDescription new createFor: tmpClass. 
	
	self assertCollection: tmpClass instVarNames hasSameElements: #( one two three).
	tmpClass 
		removeInstVarNamed: 'two';
		"addInstVarNamed: 'four';"
		addInstVarNamed: 'two'.
	self assertCollection: tmpClass instVarNames hasSameElements: #( one three two).
	desc2 := ODBClassDescription new createFor: tmpClass.
]
