
RVM Bootstrap
=============

Command to create a directory project with a configured .rvmrc into it.

Requirements
------------

Requires RVM instaled on your system.

Installation
------------

    gem install rvmbs

Usage
-----

    $ rvmbs -d my_project    
  
Generates a my_project directory with a trusted .rvmrc file contains:
    
    rvm use --create 1.9.2@my_project
  
Run `rvmbs --help` for more options.

To Do
-----

* Add tests. 
* Bundler integration. 

Copyright
---------

Copyright (c) 2012 Jorge Luis Pérez. See LICENSE for details.
