Class {
	#name : #ODBClassManagerTest,
	#superclass : #ODBDiskBasedTest,
	#instVars : [
		'classManager'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #initialization }
ODBClassManagerTest >> setUp [ 
	super setUp.
	classManager := db classManager.
]

{ #category : #running }
ODBClassManagerTest >> tearDown [ 
	super tearDown.
	classManager := nil
]

{ #category : #tests }
ODBClassManagerTest >> testClassChangeBumpsVersion [

	| classInfo classInfo2 classInfo3 tmpClass |
	self assert: classManager lastClassId equals: 0.
	tmpClass := ODBTestClass1 copy.
	classInfo := classManager registerNewClass: ODBTestClass1.
	classInfo2 := classManager registerNewClass: ODBTestClass1.
	self assert: classInfo2 equals: classInfo. 
	self assert: classInfo2 == classInfo. 
	classInfo3 := classManager registerNewClass: ODBTestClass1.
	self assert: classInfo3 equals: classInfo. 
	self assert: classManager lastClassId equals: 1.
]

{ #category : #tests }
ODBClassManagerTest >> testClassIdIncrementAfterRegister [

	| classInfo |
	self assert: classManager lastClassId equals: 0.
	classInfo := classManager registerNewClass: ODBTestClass1.
	self assert: classManager lastClassId equals: 1.
	
	self assert: classInfo classID equals: 1.
	self assert: classInfo name = 'ODBTestClass1'.
	self assert: classInfo instVarNames equals: #( one two three ).
	
]

{ #category : #tests }
ODBClassManagerTest >> testClassIdZeroAfterCreation [

	self assert: classManager lastClassId equals: 0
]

{ #category : #tests }
ODBClassManagerTest >> testRegisterMultipleTimesDoesNotChange [

	| classInfo classInfo2 classInfo3 |
	self assert: classManager lastClassId equals: 0.
	classInfo := classManager registerNewClass: ODBTestClass1.
	classInfo2 := classManager registerNewClass: ODBTestClass1.
	self assert: classInfo2 equals: classInfo. 
	self assert: classInfo2 == classInfo. 
	classInfo3 := classManager registerNewClass: ODBTestClass1.
	self assert: classInfo3 equals: classInfo. 
	self assert: classManager lastClassId equals: 1.
]
