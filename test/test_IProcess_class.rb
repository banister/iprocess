context IProcess do
  context 'spawn' do
    it 'spawns two Proc workers.' do
      topic = IProcess.spawn(2) { :ok }
      topic.must_equal([:ok, :ok])
    end

    it 'spawns two non-Proc workers.' do
      worker = 
      Class.new do
        def call
          :ok
        end
      end

      topic = IProcess.spawn(2, worker.new)
      topic.must_equal([:ok, :ok])
    end
  end

  context 'initialize' do
    it "raises if given an object who cannot respond to #call." do
      proc { IProcess.new(nil) }.must_raise(ArgumentError)
    end
  end
end
