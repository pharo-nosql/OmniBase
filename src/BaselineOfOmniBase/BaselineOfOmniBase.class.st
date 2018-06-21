Class {
	#name : #BaselineOfOmniBase,
	#superclass : #BaselineOf,
	#category : #BaselineOfOmniBase
}

{ #category : #baselines }
BaselineOfOmniBase >> baseline: spec [
	<baseline>
	
	spec for: #common do: [
		self osprocess: spec.
		
		spec package: 'OmniBase' with: [ spec requires: #('OSProcess')].
		spec package: 'OmniBase-Tests' ]
	
]

{ #category : #baselines }
BaselineOfOmniBase >> osprocess: spec [
	
	
	spec configuration: 'OSProcess' with: [ 
		spec
			versionString: #stable;
			repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main' ]
]
