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
	
	self flag: #TODO. "Temporary use of #bleedingEdge because there is no P7 compatible version yet"
	spec configuration: 'OSProcess' with: [ 
		spec
			versionString: #bleedingEdge;
			repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main' ]
]
