Beaver builds your optimized deployment ready website.
Feed it a folder and it (will be able to) convert and optimize hipster webfiles like html/css/scss/js to the most optimized version.
Even better, it will be able to autopublish.

[![Build Status](https://travis-ci.org/theimpossibleastronaut/beaver.svg)](https://travis-ci.org/theimpossibleastronaut/beaver)

Development is done in haxe using the hxcpp builder to create a native binary for your platform.

For now, no manual is provided. Ask for help, figure it out. W/e.
irc://irc.oceanius.com/#dev

Nice beaver!

Install on new machines (For linux see botom first!):

```
brew install haxe
mkdir ~/haxelib
haxelib setup ~/haxelib
haxelib install hxcpp
```

Build it:

```
haxe build.hxml
```

Run it:

```
bin/bvr
```

If it's in your path: bvr

---

If you run linux, you need to make sure you have a sane build environment first.
```
sudo apt-get update
sudo apt-get install python-software-properties -y --force-yes
sudo add-apt-repository -y ppa:eyecreate/haxe
sudo apt-get update
sudo apt-get install haxe gcc-multilib g++-multilib -y --force-yes
mkdir ~/haxelib
haxelib setup ~/haxelib
haxelib install hxcpp
```

---
 - Includes Haxmin from @YellowAfterlife , I don't like git submodules. Only modified its package.