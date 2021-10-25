Class {
	#name : #BaselineOfOmniBase,
	#superclass : #BaselineOf,
	#category : #BaselineOfOmniBase
}

{ #category : #baselines }
BaselineOfOmniBase >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec package: 'OmniBase'.
		spec package: 'OmniBase-Tests' ]
]
