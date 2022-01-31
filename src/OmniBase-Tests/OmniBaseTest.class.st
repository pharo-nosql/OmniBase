Class {
	#name : #OmniBaseTest,
	#superclass : #TestCase,
	#category : #'OmniBase-Tests'
}

{ #category : #accessing }
OmniBaseTest class >> packageNamesUnderTest [
	^ #(OmniBase)
]

{ #category : #accessing }
OmniBaseTest >> collection [

	| coll |
	coll := OrderedCollection new.
	coll
		add: 1;
		add: -1;
		add: true;
		add: false;
		add: nil;
		add: 1000;
		add: -1000;
		add: 0.0;
		add: 1.0;
		add: -123.43;
		add: 13 factorial;
		add: 215345245.3425;
		add: 2 / 3;
		add: Date today;
		add: (Time fromSeconds: 20000);
		add: $a;
		add: #symbol;
		add: '';
		add: 'Hello world';
		add: self class;
		"add: Smalltalk;"
		add: (Dictionary new at: 'key' put: 'value'; yourself);
		add: IdentityDictionary new;
		add: (Array with: 'a' with: 'b');
		add: coll.
	^coll
]
