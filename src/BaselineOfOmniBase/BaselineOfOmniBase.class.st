Class {
	#name : #BaselineOfOmniBase,
	#superclass : #BaselineOf,
	#category : #BaselineOfOmniBase
}

{ #category : #baselines }
BaselineOfOmniBase >> baseline: spec [
	<baseline>
	
	spec for: #commo do: [
		spec package: 'OmniBase' ]
	
]
