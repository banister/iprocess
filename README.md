__OVERVIEW__


| Project         | IProcess    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/IProcess
| Documentation   | http://rubydoc.info/gems/iprocess/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  The purpose of IProcess is to allow you(the developer) to run units of work
  in parallel to each other. If you were to get down to implementation details
  you'd see I'm using Kernel#fork to spawn subproccesses as units of work.

  As a bonus the parent process can collect the return value of each unit of 
  work as long as it is serializable (i.e: Marshal can dump & load it).

__EXAMPLES__

The first two examples(one & two) are using the synchronous APIs, a little below
those(3) demos the asynchronous API.

__1.__

A single subprocess is spawned:
  
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

A single subprocess is spawned asynchronously.  
When the subprocess completes, ':hi' is sent to `obj#recv` from another thread.

    obj = Object.new
    def obj.recv(msg)
      msg.to_s.capitalize!
    end

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

__INSTALL__

gem install iprocess
