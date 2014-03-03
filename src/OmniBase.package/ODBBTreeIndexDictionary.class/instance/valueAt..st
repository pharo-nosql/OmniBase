private
valueAt: key 
	"Private - Answer persistent object value at key  with right version loaded."

	^self valueAt: key ifAbsent: [ODBValueHolder new]