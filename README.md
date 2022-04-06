Omnibase
========
[![CI matrix](https://github.com//ApptiveGrid/MoniBase/actions/workflows/build.yml/badge.svg)](https://github.com//pharo-nosql/Omnibase/actions/workflows/build.yml)



OmniBase is a Smalltalk efficient object repository. Based on [BTrees](http://en.wikipedia.org/wiki/B-tree) and the filesystem, it has full [ACID](http://en.wikipedia.org/wiki/ACID) features. It also provides multi version concurrency control.

Omnibase uses now a unified FFI based implementations for fnctl calls for locking. Because of this the minimal supported version has changed to Pharo9.
### Loading 


Use this snippet to load it into your [Pharo9](http://www.pharo.org) image:

```Smalltalk
Metacello new 
	repository: 'github://pharo-nosql/OmniBase/src';
	baseline: 'OmniBase';
	load.
```

---

This is the Pharo Smalltalk port of David Gorisek's original work. Originally at squeaksource, now moved to github.

For an intro, take a look at [this presentation on slideshare](http://www.slideshare.net/esug/omni-baseobjectdatabase) and have a look in the [Docs](documentation/) folder

### Contributions

...are welcomed, send that push request and hopefully we can review it together

MIT - License
