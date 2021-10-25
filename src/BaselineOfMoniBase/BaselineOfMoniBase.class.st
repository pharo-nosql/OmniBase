Class {
	#name : #BaselineOfMoniBase,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoniBase
}

{ #category : #baselines }
BaselineOfMoniBase >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec package: 'OmniBase'.
		spec package: 'OmniBase-Tests' ]
]
