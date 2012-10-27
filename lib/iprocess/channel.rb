class IProcess::Channel

  #
  # @param [#dump,#load}] serializer
  #   Any object that implements dump, & load.
  #   Defaults to {IProcess.serializer}.
  #
  # @yieldparam [IProcess::Channel] _self
  #   Yields self.
  #
  def initialize(serializer = IProcess.serializer) 
    @reader, @writer = IO.pipe
    @serializer = serializer 
    if block_given?
      yield self
    end
  end

  #
  # Is the channel closed?
  #
  # @return [Boolean]
  #   Returns true if the channel is closed.
  #
  def closed?
    @reader.closed? && @writer.closed?
  end

  #
  # Is the channel open?
  #
  # @return [Boolean]
  #   Returns true if the channel is open.
  #
  def open?
    !closed?
  end

  #
  # Write a object to the channel.
  #
  # @param [Object] object
  #   A object to add to the channel.
  #
  def write object
    if open?
      @reader.close
      @writer.write @serializer.dump(object)
      @writer.close
    end
  end

  #
  # Receive a object from the channel.
  #
  # @return [Object]
  #   The object added to the channel.
  #
  def recv
    if open?
      @writer.close
      obj = @serializer.load @reader.read
      @reader.close
      obj
    end
  end

end
