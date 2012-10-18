__OVERVIEW__


| Project         | IProcess    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/IProcess
| Documentation   | http://rubydoc.info/gems/iprocess/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  IProcess takes the pain out of InterProcess Communication(IPC) by providing 
  a number of abstractions on top of spawning subprocesses and interprocess 
  communication. It has a simple and easy to use API that supports synchronous 
  and asynchronous method calls plus a few other useful features that will become
  obvious in the examples below. :-)

__EXAMPLES__

The first two examples(one & two) are using the synchronous APIs, a little below
those(3) demos the asynchronous API.

__1.__

A subprocess is spawned:
  
    messages = IProcess.spawn { {msg: "hello"} }
    p messages # => [{msg: "hello"}]

__2.__

You can spawn a subprocess with a block or with any object that responds to 
`#call`. If you had a worker that was too complicated as a block you could 
try this:

    class Worker
      def initialize
        @num = 1
      end

      def call
        @num + 1
      end
    end
    IProcess.spawn(5, Worker.new) # => [2, 2, 2, 2, 2]

__3.__

A subprocess is spawned asynchronously. 

    class Inbox
      def initialize
        @messages = []
      end

      def recv(msg)
        @messages << msg
      end
    end
    inbox = Inbox.new
    jobs = IProcess.spawn! { Process.pid }
    jobs.map { |job| job.report_to(inbox) }


__PLATFORM SUPPORT__

_supported_

  * Rubinius (1.9 mode) 
  * CRuby (1.9)

_unsupported_
  
  * CRuby 1.8
  * MacRuby
  * JRuby

__LICENSE__

MIT. See LICENSE.txt.

__INSTALL__

    $ gem install iprocess
