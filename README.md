OmniBase
========

OmniBase is a Smalltalk efficient object repository. Based on [BTrees](http://en.wikipedia.org/wiki/B-tree) and the filesystem, it has full [ACID](http://en.wikipedia.org/wiki/ACID) features.

Truth should be told, this software is old and doesn't have elegant code. **But**... it works really well for many scenarios and has a remarkable performance.

In *nix systems it requires [mandatory file locking](http://www.hackinglinuxexposed.com/articles/20030623.html), so be sure you use mand on your fstab.

For a clean API using it, check: [Aggregate](https://github.com/sebastianconcept/Aggregate)


###Loading 

Use this snippet to load it into your [Pharo](http://www.pharo.org)* image:

    Metacello new 
		repository: 'github://estebanlm/OmniBase/src';
		baseline: 'OmniBase';
		load.


---
This is the Pharo Smalltalk port of David Gorisek's original work. Originally at squeaksource, now moved to github.

This is a fork from Sebastian's original port.

For an intro, take a look at [this presentation on slideshare](http://www.slideshare.net/esug/omni-baseobjectdatabase)

###Contributions

...are welcomed, send that push request and hopefully we can review it together

###*Pharo Smalltalk
Getting a fresh Pharo Smalltalk image and its virtual machine is as easy as running in your terminal:
 
    wget -O- get.pharo.org | bash

_______

MIT - License

2014 - [sebastian](http://about.me/sebastianconcept)
2018 - [esteban](http://github.com/estebanlm)

o/