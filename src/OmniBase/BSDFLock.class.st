Class {
	#name : #BSDFLock,
	#superclass : #FLock,
	#category : #'OmniBase-FLock'
}

{ #category : #'field definition' }
BSDFLock class >> fieldsDesc [
	"self rebuildFieldAccessors"

	^ #(
	__off64_t l_start;
	__off64_t l_len;
	__pid_t l_pid;	
	int l_type;
	int l_whence;
	)
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_len [
	"This method was automatically generated"
	^handle unsignedLongLongAt: OFFSET_L_LEN
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_len: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: OFFSET_L_LEN put: anObject
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_pid [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_L_PID
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_pid: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_L_PID put: anObject
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_start [
	"This method was automatically generated"
	^handle unsignedLongLongAt: OFFSET_L_START
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_start: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: OFFSET_L_START put: anObject
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_type [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_L_TYPE
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_type: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_L_TYPE put: anObject
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_whence [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_L_WHENCE
]

{ #category : #'accessing - structure variables' }
BSDFLock >> l_whence: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_L_WHENCE put: anObject
]
