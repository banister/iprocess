__OVERVIEW__


| Project         | IProcess    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/IProcess
| Documentation   | http://rubydoc.info/gems/iprocess/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

 An alternative approach to InterProcess Communication(IPC).

__EXAMPLES__

The first two examples(one & two) are using the synchronous APIs, a little below
those(3) demos the asynchronous API.

__1.__

A single unit of work is spawned:
  
    message = IProcess.spawn { [:yes, :no] }
    p message # => [[:yes, :no]]

__2.__

A unit of work does not need to be a block, though, and the number of 
subprocesses you can spawn is variable (5, in this example):

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

A unit of work is spawned asynchronously.  
When the unit of work completes, ':hi' is sent to `obj#recv` from another thread.

    obj = Object.new
    def obj.recv(msg) msg.to_s.capitalize! end
    jobs = IProcess.spawn! { :hi }
    jobs.map { |job| job.report_to(obj) }


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
