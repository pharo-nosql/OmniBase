Class {
	#name : #ODBTransactionTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBTransactionTest >> testDoubleNestedContainer [
	| testString second transaction transaction2 third nestednestedstring nestedDict |
	second := db objectManager containerNew: 'second'.
	third := db objectManager containerNew: 'third'.
	transaction := db newTransaction.
	nestednestedstring := 'nestednestedstring'.
	transaction store: nestednestedstring in: 'third'.
	nestedDict := Dictionary new 
		at: 'nestedkey' put: nestednestedstring;
		yourself.
	transaction store: nestedDict in: 'second'.
	transaction root at: 'dict' put: nestedDict.
	testString := 'myteststring'.
	transaction commit.
	self assert: db objectManager containers size equals: 3.
	transaction2 := db newTransaction. 
	self assert: (transaction2 root at: 'dict')  isODBReference.
	self assert: ((transaction2 root at: 'dict') at: 'nestedkey')  isODBReference.
	self assert: (db objectManager containerNamed: 'second') numberOfObjects equals: 1.
	self assert: (db containerNamed: 'third') numberOfObjects equals: 1.
]

{ #category : #tests }
ODBTransactionTest >> testReadOnlyTransaction [
	| transaction accountA accountB balanceB oldBalanceA oldBalanceB |
	"populate accounts"
	[  OmniBase root at: 'Accounts'  put: (Dictionary new 
		at: 'A' put: (Account new balance: 100);
		at: 'B' put: (Account new balance: 200);
		yourself)] evaluateAndCommitIn: db newTransaction.
	
	"create transaction at a point in time before the modifying transaction"
	transaction := db newReadOnlyTransaction.
	oldBalanceA := ((transaction root at: 'Accounts') at: 'A') balance.
	self assert: oldBalanceA equals: 100.
	oldBalanceB := ((transaction root at: 'Accounts') at: 'B') balance.
	self assert: oldBalanceB equals: 200.
	
	accountA := (transaction root at: 'Accounts') at: 'A'.
	accountB := (transaction root at: 'Accounts') at: 'B'.
	accountA transfer: 1000 to: accountB.
	transaction markDirty: (transaction root at: 'Accounts').
	transaction commit.
	
	"now check if it was not commited"
	transaction := db newTransaction.
	
	"now get balance of account B" 
	balanceB := ((transaction root at: 'Accounts') at: 'B') balance.
	"should be still the old value as the re-only transaction should have no impact"
	self assert: balanceB equals: 200.
]

{ #category : #tests }
ODBTransactionTest >> testReferenceToSecondContainer [
	| testString second transaction transaction2 |
	second := db newContainer: 'second'.
	self assert: (db existsContainerNamed: 'second').
	transaction := db newTransaction.
	testString := 'myteststring'.
	transaction store:  testString in: 'second'.
	transaction root at: 'test1' put: (OrderedCollection new 
		add: testString;
		yourself).
	transaction commit.
	self assert: db objectManager containers size equals: 2.
	transaction2 := db newTransaction. 
	self assert: (transaction2 root at: 'test1') first isODBReference.
	self assert: (db containerNamed: 'second' ifAbsent: [self error]) numberOfObjects equals: 1.
]

{ #category : #tests }
ODBTransactionTest >> testTransactionPreservesState [
	| transaction  transaction2 accountA accountB balanceB oldBalanceA oldBalanceB |
	"populate accounts"
	[  OmniBase root at: 'Accounts'  put: (Dictionary new 
		at: 'A' put: (Account new balance: 100);
		at: 'B' put: (Account new balance: 200);
		yourself)] evaluateAndCommitIn: db newTransaction.
	
	"create transaction at a point in time before the modifying transaction"
	transaction := db newTransaction.
	"get account A balance"
	oldBalanceA := ((transaction root at: 'Accounts') at: 'A') balance.
	self assert: oldBalanceA equals: 100.
	oldBalanceB := ((transaction root at: 'Accounts') at: 'B') balance.
	self assert: oldBalanceB equals: 200.
	"start another transaction in parallel and make the transfer in transaction 2 "
	transaction2 := db newTransaction.
	accountA := (transaction2 root at: 'Accounts') at: 'A'.
	accountB := (transaction2 root at: 'Accounts') at: 'B'.
	accountA transfer: 1000 to: accountB.
	self assert: accountA balance equals: -900.
	self assert: accountB balance equals: 1200.
	transaction2 commit.
	
	"now get balance of account B" 
	balanceB := ((transaction root at: 'Accounts') at: 'B') balance.
	"should be still the old value as the transaction should snapshot data to the time 
	of transaction creation"
	self assert: balanceB equals: 200
]
