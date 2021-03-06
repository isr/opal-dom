describe "Element#class_name" do
  before do
    @div = Element.new <<-HTML
      <div id="class-name-spec">
        <div id="foo" class="whiskey"></div>
        <div id="bar" class="scotch brandy"></div>
        <div id="baz" class=""></div>
        <div id="buz"></div>

        <div class="red dark"></div>
        <div class="red light"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the Elements' classname" do
    Document['#foo'].class_name.should == 'whiskey'
    Document['#bar'].class_name.should == 'scotch brandy'
  end

  it "should return an empty string for Elements with no classname" do
    Document['#baz'].class_name.should == ''
    Document['#buz'].class_name.should == ''
  end
end

describe "Element#class_name=" do
  before do
    @div = Element.new <<-HTML
      <div id="set-class-name-spec">
        <div id="foo" class=""></div>
        <div id="bar" class="oranges"></div>

        <div id="baz" class="banana"></div>
        <div id="buz" class="banana"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should set the given class name on the Element" do
    Document['#foo'].class_name = 'apples'
    Document['#foo'].class_name.should == 'apples'
  end

  it "should replace any existing classname" do
    bar = Document['#bar']
    bar.class_name.should == 'oranges'

    bar.class_name = 'lemons'
    bar.class_name.should == 'lemons'
  end
end