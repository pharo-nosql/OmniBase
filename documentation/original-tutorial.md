OmniBase Tutorial
=================

Creating, opening and closing the database
------------------------------------------

Before objects can be made persistent the database files have to be created on you and the database has to be opened. Database can be created either on your local filesystem on a shared network drive. To create the database use the following expression:

```
db := OmniBase createOn: 'c:\temp\MyDB'.
```

After evaluating this expression there will be a database created in the directory. If the directory `MyDB` does not already exist it will be automatically created. If there already a database in the directory an exception will be signaled.

Now after the database is created you can already use the database or close it with

```
db close.
```

The database can later be opened simply using the following expression:

```
db := OmniBase openOn: 'c:\temp\MyDB'.
```

The method #openOn: answers object which represents the opened database session.  You can for example find out how many users are currently working with it by evaluating:

```
db numberOfClients
```

Or you can begin a transaction for storing and retrieving objects from the database.  This is explained in the following chapters. 

When you see that we are using variable `db` you know that it refers to the opened database session.

Persistent objects, database root and transactions
--------------------

First thing one has to remember about object databases is that every time an object is stored into the database, it has to happen inside a transaction. 

Transactions can be a unit of work. It transforms the database from one consistent state to another (and for every other user) as one atomic operation. 

And once the transaction completes safely it is completely done. If the transaction cannot be completed safely, it is reveresed, as if nothing happens at all. 

From user's point of view an example of a transaction could be editing a person's data. First when the transaction begins the p is loaded from the database, locked and displayed in a dialog window. Then the user changing the data and when he is done he clicks either the Ok button or the Cancel. If the Cancel button was clicked the transaction is committed otherwise it is aborted.

The basic scenario for accessing the database is:
```
begin transaction
get, create or change persistent objects
commit or abort transaction
```

In OmniBase this can be done like this:

```
[
   OrderedCollection newPersistent
      add: 'string object';
      add: 1;
      add: Date today ] evaluateAndCommitIn: db newTrans
```

As you can see in this example we have created a new persistent `OrderedCollection` and added some objects to it. 

Since the block was evaluated with message `#evaluateAndCommitIn:` the system knew in which transaction the database is being accessed. 

After the block is evaluated, the transaction is committed. When transaction commits the newly created persistent `OrderedCollection` is stored into the database. Now we could store any other Smalltalk object into the database the same way that as we have stored the collection in the example.

In the example above the transaction is used implicitly inside the block. The same by referencing the transaction explicitly like this:

```
txn := db newTransaction.
txn makePersistent: (OrderedCollection new
   add: 'string object';
   add: 1;
   add: Date today;
   yourself).
txn commit.
```

The only difference between these two ways is that in the first case the transaction is automatically aborted if an error occurs during the evaluation of the block. In the l? would have to use `#ifCurtailed:` to do it separately.

Now we have seen how to make objects persistent.

But once the object is already in database how do we get it back? 

Well in the example above there is no way to get it back! We have lost all references to it. And if there is no one referencing the object it will be garbage collected during the next database garbage collection (the same as it happens in memory with every transient object). 

This is where the database root object comes.

So let us now do it right:

```
[ OmniBase root
 at: 'test' put: (OrderedCollection newPersistent
    add: 'string object';
    add: 1;
    add: Date today;
    yourself) ] evaluateAndCommitIn: db newTransaction
```

Database root is like an entry point into the database. 

Initially when you create the root is an instance of a `Dictionary` (`ODBPeristentDictionary` which is a subclass of `Dictionary` to be exact). Every persistent object is either directly or indirectly referenced by the root. This is also called persistence by reachability. 

So to fetch an object from the database you need to know how to navigate through all the persistent objects to get it. 

You can later get the stored collection back just with:

```
[ coll := OmniBase root at: 'test'.
"now let's change the persistent collection"

coll add: 'Another object'.
"notify transaction that the collection has been changed and that it has to be written into the database"
coll markDirty
] evaluateAndCommitIn: db newTransaction.
```

Also note from the example above that we had to explicitly notify the transaction that persistent collection is changed. Without sending `#markDirty` no change would be sent to the database upon transaction commit. 

This is necessary since there is no notification mechanism implemented in the usual `OrderedCollection` which would notify the transaction an element was added to the collection. 

This is also the reason why the database root is an instance of a class `ODBPersistentDictionary` which automatically notifies the transaction any time an association is added, changed or removed.

In our example we have placed the collection directly in the database root. Usually people do not do it like this but use more complex strategies for storing objects. 

The database therefore contain only top-level objects like dictionaries of all persons, contracts etc. For a particular person, we would first get dictionary of all persons and later get the person's contracts. 

For example to fetch a person with id number 343 we would use:

```
person := (db newTransaction root at: 'persons') at: 343. 
```

From here on we would navigate through object relations to get person's contracts etc. depending on our object model.

Object clustering
-----------------

When an object is made persistent in OmniBase this means that at some point the object must be serialized into a series of bytes which can then be stored onto the database file. 

Because every object can reference any number of other Smalltalk objects it has to be determined which objects will be serialized together and which should be serialized separately. Therefore when we say persistent object we really should be saying  objects that are serialized together and are being given an object identifier - `OID`. 

T be shown on the following example:

```
[ | coll1 coll2 str |

coll1 := OrderedCollection new.
coll2 := OrderedCollection new.
str := 'This is a string'.
coll1 add: str.
coll2 add: str.

OmniBase root at: 'one' put: coll1.
OmniBase root at: 'two' put: coll2. ]
   evaluateAndCommitIn: db newTransaction.
[ | coll1 coll2 |
coll1 := OmniBase root at: 'one'.
coll2 := OmniBase root at: 'two'.
coll1 first isIdenticalTo: coll2 first ]
   evaluateIn: db newTransaction.
```

Evaluate the example above with 'Display It' and you will see that it will evaluates `false` regardless of the fact that both collections were referencing the identical string obj have saved them in a block that executed before. 

Now let us make a string persistent & evaluate the slightly changed example again:

```
[ | coll1 coll2 str |

coll1 := OrderedCollection new.
coll2 := OrderedCollection new.
str := 'This is a string'.
str makePersistent.
coll1 add: str.
coll2 add: str.
OmniBase root at: 'one' put: coll1.
OmniBase root at: 'two' put: coll2. ]
   evaluateAndCommitIn: db newTransaction.
[ | coll1 coll2 |
coll1 := OmniBase root at: 'one'.
coll2 := OmniBase root at: 'two'.
coll1 first isIdenticalTo: coll2 first ]
   evaluateIn: db newTransaction.
```

As you can see the whole expression now evaluates to `true`. 

So what's the difference? Lets take a look at how objects are stored in each of these two examples. 

In the first, the string object was not made persistent on its own. Therefore it was stored as a part collection object since it was referenced out of it. Each of the collection objects go object id in the database and was stored as a cluster of objects. The following figure these two clusters:

As we can imagine when these two objects are later loaded each of them will get id of the string object. However in the second example the objects will be stored as f

This means that there will be three independent persistent objects (clusters) and the collections will reference exactly the same string object. 

Understanding the notion of clustering objects is essential when developing an application with OmniBase since decisions on how to cluster your objects can have very big impact on the scalability performance of your application.

Probably you have also noticed that we have used message `#isIdenticalTo:` instead of `#==`. This is necessary because the database will not load all objects from the database.

Instead all references to objects which are located outside of the cluster being load not loaded yet will be replaced by proxy objects. Those proxy objects will catch the message sent to them and load the real object before forwarding the message to it. 

All messages will be directly forwarded to the underlying object. As you can see then the real object coexist and both represent the same object. But since they are two o usual identity operator `#==` will not work. That is why you should use the `#isIdenticalTo:` message for checking identity of objects when using the database. 

The message `#isIdenticalTo:` is also clever enough not to load the real object only for checking identity but instead checks its identity based on its unique `oid`.

Object locking and concurrency
------------------------------

OmniBase uses multi-version concurrency control in order to internally serialize transactions running concurrently. This basically means that a persistent object can have many versions the database. Each time an object is changed a new version is created in the database after the transaction in which the object has been changed commits. This new version then becomes visible to every newly started transaction. 

Multi-version concurrency control has many advantages compared with lock based version control where a combination of read and write locks is used to preserve consistency of traansactions. The biggest advantage is that long transactions become possible. An example of a long transaction is when a user clicks on an object to open a properties window/pane where the object can be changed. So the transaction would look similar to this:
```
start transaction and fetch the object being edited
open the properties dialog so that a user can begin changing the object. Set a lock on the object to prevent other users from changing it while it is being edited
if user pressed button OK then commit transaction, else abort transaction
```
If we were using read-locks everybody else would not be able to look at the object being edited. But in OmniBase it is still possible to read the object in its consistent state when it is being edited and thus locked for writing only.

Note that we wrote 'to read the object in its consistent state'. This phrase could be explained with the following example. Let us have an account A and account B and transfer an amount from account A to account B:

```
t1 := db newTransaction.

"get account A balance"

balanceA := ((t1 root at: 'Accounts') at: 'A') balance.
"start another transaction in parallel and make the transfer in transaction 2 "
t2 := db newTransaction.
accA := (t2 root at: 'Accounts') at: 'A'.
accB := (t2 root at: 'Accounts') at: 'B'.
accA transfer: 1000 to: accB.
newBalance := accB balance.
t2 commit.
"now get balance of account B"

balanceB := ((t1 root at: 'Accounts') at: 'B'.
```

From this example you can see that although the transaction 1 accessed the account after the transaction 2 already committed its changes, the user will still get the object value in order to preserve transaction integrity in transaction 1. So in transaction 1 amount of money stays the same as in transaction 2 even though the money has been moved from one account to another.

In the example above you can also notice that the value that you are getting from a transaction may not necessarily be the newest value in the database.

To insure you are reading value you can user explicit write locks when needed. The following example shows how you could implement a method which would generate unique integer identifiers (count multi-user environment):

```
[t := db newTransaction.
lastId := t root at: 'lastCustomerId'.
t lock: lastId ]
whileFalse: [t abort].
lastId increment.
t commit.
^lastId
```

So far we talked only about object locks but there are three levels of locking in Omnibase.   These are:

 - global lock - global lock can be set on a database only when no other lock i one is updating the database at the same time. After setting the global lock t has set it can run only one update transaction on the database. During that time the user will be able to update the database but every one will still be able to read objects.  The locks can be set using messages `#globalLock`, `#globalUnlock` and `#isGlobal` database session object (instances of class OmniBase). 
 - object lock - an object lock prevents the object from being changed by another user during the time the lock is set. The transaction that has set the lock has to be explicitly calling `#abort` or `#commit` if it is not executed in a guarded block. The object can not be locked if the version being locked is not its newest ve another transaction/user has already obtained a lock or if a global lock is set user. Object lock can be explicitly set or removed using messages `#lock:` and on a transaction. 
 - dictionary key lock - enables a higher granularity of updates in a multi-use dictionary where many users can update a single dictionary at the same time conserving the consistency of the data it contains. Setting a lock on a particular b-tree dictionary will prevent others from changing the value associated with a particular key. It will also prevent others from removing the key from the dictionary.  The lock can not be set if the value associated with the key in transaction is not t one (it has been already changed in another transaction) or if another user has locked that key or if a global lock has been set on the whole database. A key explicitly locked or unlocked using messages `#lockKey:` and `#unlockKey:` on dictionary object.
