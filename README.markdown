RVM Bootstrap
=============

Command to create a directory project with a configured .rvmrc into.

Requirements
------------

Just RVM installed.


Installation
-----------

    gem install rvmbs

Usage
-----

    $ rvmbs -d my_project    
  
Generates a my_project directory with a trusted .rvmrc file contains:
    
    rvm use --create 1.9.2@my_project
  
Run `rvmbs --help` or `gem man rvmbs` for more options.

Config File
-----------

rvmbs use a config file (yaml) on your home dir: '.rvmbsrc'

    implementation: 1.9.3q

To Do
-----

* Add tests. 
* Bundler integration.

Copyright
---------

Copyright (c) 2012 Jorge Luis Pérez. See LICENSE for details.

