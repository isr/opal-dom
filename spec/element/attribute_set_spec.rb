describe "Element#[]=" do
  before do
    @div = Element.new <<-HTML
      <div id="attribute-set-spec">
        <div id="foo" title="Apples"></div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should set the attribute value on the element" do
    bar = Document['#bar']

    bar[:title].should == ""
    bar[:title] = 'Oranges'
    bar[:title].should == "Oranges"
  end

  it "should replace the old value for the attribute" do
    foo = Document['#foo']

    foo[:title].should == 'Apples'
    foo[:title] = 'Pineapple'
    foo[:title].should == 'Pineapple'
  end
end