describe '#Barney' do

  it 'should synchronize a local variable.' do
    name = 'Robert'

    Barney do
      share :name
      fork { name.slice! 3..5}
      fork { name.slice! 1..2 }
    end

    assert_equal "R", name
  end

  it 'should synchronize an instance variable.' do
    @foo = 'bar'

    Barney do
      share :@foo
      fork { @foo = "baz" }
    end

    assert_equal "baz", @foo
  end

end
