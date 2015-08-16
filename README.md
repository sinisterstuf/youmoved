YOUMOVED [ ![Build status](http://img.shields.io/codeship/e6c959b0-265a-0133-4abc-42218616331f.svg)](https://www.codeship.io/projects/97063)
=========

*Send location-Yo to see how far you moved*

**YOUMOVED** is a simple location-based service for measuring distances using
the Yo API.  It's as simple as sending a location-Yo, walking and sending
another location-Yo to get the distance from the previous one.

Usage
-----

1. install [Yo](https://www.justyo.co/)
2. add **YOUMOVED**
3. tap to get instructions
4. double-tap to send location
5. double-tap from somewhere else to get the distance since the last Yo

Developing
----------

Set up environment:

    rvm 2.2.2
    bundle install

Run tests:

    bundle exec ruby tests.rb

Start web app:

    bundle exec ruby app.rb

---
Copyright (C) 2014 Siôn le Roux (see [LICENSE.txt](LICENSE.txt) for more information)
