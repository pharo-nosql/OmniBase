Class {
	#name : #ODBWeakValueIdentityDictionaryTest,
	#superclass : #ODBIdentityDictionaryTest,
	#category : #'OmniBase-Tests'
}

{ #category : #running }
ODBWeakValueIdentityDictionaryTest >> setUp [
	super setUp.
	dict := ODBWeakValueIdentityDictionary new
]
