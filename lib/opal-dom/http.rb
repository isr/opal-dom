# Wrapper around native `XMLHttpRequest` object to perform ajax calls.
class HTTP

  # HTTP.get
  #
  #   HTTP.get("api/users/1") do |res|
  #     alert "got result"
  #   end
  #
  # @param [String] url url to get
  # @param [Hash] options any options to use
  # @return [HTTP] returns new instance
  def self.get(url, options={}, &action)
    options[:action] = action if block_given?
    self.new url, :get, options
  end

  # The response body from the request. This will be nil until the
  # request is completed.
  #
  #   HTTP.get("api/users/1") do |res|
  #     alert "result: #{res}"
  #   end
  # 
  # @return [String]
  attr_reader :body

  # The status number of the request.
  #
  #   HTTP.get("api/users/1") do |res|
  #     if res.status = 404
  #       raise "we got a 404!"
  #     else
  #       alert "got result!"
  #     end
  #   end
  #
  # @return [Numeric]
  attr_reader :status

  # Returns a new HTTP instance and starts the connection. It is
  # recomended to use one of the class level methods instead, e.g.
  # HTTP#get.
  #
  #   HTTP.new("api/users/1", :get)
  #
  # @param [String] url
  # @param [String] method
  # @param [Hash] options
  def initialize(url, method, options={})
    @action = options[:action]
    %x{
      var xhr = this.xhr = make_xhr(), http = this;

      xhr.open(method.toUpperCase(), url, true);
      xhr.onreadystatechange = function() {
        #{ `http`.on_state_change };
      }

      xhr.send(null);
    }
  end

  # Convenience method to parse the body of the response through JSON.
  # An error will be raised if the response is not valid json.
  #
  #   HTTP.get("api/users.json") do |res|
  #     puts res.json
  #   end
  #
  # @return [Hash, Array] json response
  def json
    JSON.parse @body
  end

  # Returns true if this request succeeded, false otherwise.
  #
  #   HTTP.get('foo.html') do |res|
  #     if res.ok?
  #       puts "it worked!"
  #     end
  #   end
  #
  # @return [true, false]
  def ok?
    `this.status >= 200 && this.status < 300`
  end

  # Handles the native xhr object `onreadystatechange` callback. You
  # shouldn't call this method directly.
  #
  # @private
  def on_state_change
    xhr = @xhr
    return if `xhr.readyState != 4`

    # accessing status breaks sometimes
    begin
      @status = `xhr.status`
    rescue => e
      @status = 0
    end

    @body = `xhr.responseText || ''`

    @action.call self
  end

  # Create a native xhr object
  %x{
    var make_xhr = function() {
      if (typeof XMLHttpRequest !== 'undefined' && (window.location.protocol !== 'file:' || !window.ActiveXObject)) {
        return new XMLHttpRequest();
      } else {
        try {
          return new ActiveXObject('Msxml2.XMLHTTP.6.0');
        } catch(e) { }
        try {
          return new ActiveXObject('Msxml2.XMLHTTP.3.0');
        } catch(e) { }
        try {
          return new ActiveXObject('Msxml2.XMLHTTP');
        } catch(e) { }
      }

      #{ raise "Cannot make request" };
    }
  }
end