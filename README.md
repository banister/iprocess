 ![Barney Picture](http://i.imgur.com/VblLQ.png)

Barney makes the sharing of data between processes easy and _natural_ by providing a simple and easy to use DSL.  
Barney is developed against Ruby 1.9.1 and later, but it may work on earlier versions of Ruby as well.

Limitations  
-----------

* Sharable objects  
  Behind the scenes, Barney is using Marshal to send data between processes.  
  Any object that can be dumped through Marshal.dump can be shared.  
  This excludes anonymous modules, anonymous classes, Proc objects, and possibly some other objects I
  cannot think of.

* Thread safety  
  Barney is thread-safe as long as one instance of Barney::Share is used per-thread.  
  There is a mutex lock in place, but it only concerns Barney::Share#synchronize, where data is shared
  among all instances of Barney::Share.

Examples
--------

Okay, now that we've got that out of the way, let's see what using Barney is like:  
(The [Samples](https://github.com/robgleeson/barney/tree/develop/samples) directory has more examples …)

**Barney::Share**

      #!/usr/bin/env ruby
      require 'barney'

      obj = Barney::Share.new
      obj.share :message
      message = 'Hello, '

      pid = obj.fork do 
        message << 'World!'
      end

      Process.wait pid
      obj.sync
      
      puts message # 'Hello, World!' 


      
**Barney (Module)** 

The Barney module will forward requests onto an instance of Barney::Share:

      #!/usr/bin/env ruby
      require 'barney'

      Barney.share :name
      name = 'Robert'

      pid = Barney.fork do 
        name.slice! 0..2
      end

      Process.wait pid
      Barney.sync

      puts name # "Rob"

Install
--------

RubyGems.org  

      gem install barney

Github  

      git clone git://github.com/robgleeson/barney.git
      cd barney
      gem build *.gemspec
      gem install *.gem

I'm following the [Semantic Versioning](http://www.semver.org) policy.  

Documentation
--------------

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/barney/master/)
* [0.10.0](http://rubydoc.info/gems/barney/0.10.0/)
* [0.9.1](http://rubydoc.info/gems/barney/0.9.1/)
* [0.9.0](http://rubydoc.info/gems/barney/0.9.0/)
* [0.8.1](http://rubydoc.info/gems/barney/0.8.1/)
* [0.8.0](http://rubydoc.info/gems/barney/0.8.0/)
* [0.7.0](http://rubydoc.info/gems/barney/0.7.0)
* …


License
--------

Barney is released under the Lesser GPL(LGPL).  


