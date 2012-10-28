class IProcess
  require_relative 'iprocess/version'
  require_relative 'iprocess/channel'
  
  class << self
    #
    # @return [#load,#dump]
    #   Returns the serializer used by IProcess.
    #
    def serializer 
      @serializer || Marshal
    end

    #
    # @param [#load,#dump] obj
    #   Any object that implements #load, & #dump.
    #   Examples could be JSON & Marshal.
    #
    def serializer=(obj)
      @serializer = obj
    end

    #
    # @overload spawn(number_of = 1, worker)
    #
    #   Spawn one or more subprocesses.
    #
    #   @param [Integer] number_of
    #     The number of subprocesses to spawn.
    #
    #   @param [#call] worker
    #     The unit of work to execute in a subprocess.
    #
    #   @return [Array<Object>]
    #     The return value(s) of the unit(s) of work.
    #     
    def spawn(*args, &worker)
      fork(*args, &worker).map(&:result)
    end

    #
    # @overload
    #   
    #   Spawn one or more subprocesses asynchronously.
    #
    #   @param
    #     (see IProcess.spawn)
    #
    #   @return [Array<IProcess>]
    #     An array of IProcess objects. See {#report_to}.
    #
    def spawn!(*args, &worker)
      fork *args, &worker
    end
  
    def fork(number_of = 1, obj = nil, &worker)
      worker = obj || worker
      Array.new(number_of) do
        IProcess.new(worker).tap { |job| job.execute }
      end
    end
    private :fork
  end

  #
  # @param [#call] worker
  #   A block or any object that implements #call.
  #
  # @raise [ArgumentError]
  #   If 'worker' does not respond to #call.
  #
  # @return [IProcess]
  #   Returns self.
  #
  def initialize(worker)
    @worker  = worker
    @channel = nil
    @pid = nil
    unless @worker.respond_to?(:call)
      raise ArgumentError,
            "Expected worker to implement #{@worker.class}#call"
    end
  end

  #
  # @param [#recv] obj
  #   An object that will receive messages.
  #
  # @return [void]
  #
  def report_to(obj)
    thr = Thread.new do
      Process.wait @pid
      obj.recv @channel.recv
    end
    pid = Process.pid
    at_exit do
      if pid == Process.pid && thr.alive?
        thr.join
      end
    end
  end

  #
  # Executes a subprocess.
  #
  # @return [Fixnum]
  #   The process ID of the spawned subprocess.
  #
  def execute
    @channel = IProcess::Channel.new
    @pid = fork { @channel.write(@worker.call) }
  end

  #
  # @return [Object]
  #   Returns the return value of the unit of work.
  #
  def result
    Process.wait(@pid)
    @channel.recv
  end
end
