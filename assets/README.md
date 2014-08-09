Notes
=====

Under this directory, a *js* directory should exist. This *js*  is used to store client-side JavaScript. This should be installed using [Bower](http://bower.io). The [bower.json file](bower.json) is intended as a note for package dependencies. Go to parent directory of this dir where *bower.json* reside and then `bower install` to install them. All of js package are not included here for simplicity reasons. Once I see the need to put them all together, then I will put them all here. In the meantime, install them by yourself.

My $HOME/.bowerrc configuration file consists of these lines:

```
{
		"directory" : "js"
}
```

That is why all of js clients will be installed inside *js* dir. Check yours and make your own adjustment.
