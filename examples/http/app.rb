require 'opal-dom'

Document.ready? do
  # good http request
  Document['#http-1'].on :click do
    HTTP.get("files/plain.txt") do |res|
      alert "result: #{res.body}"
    end
  end

  # json result
  Document['#http-2'].on :click do
    HTTP.get("files/data.json") do |res|
      alert "result: #{res.json}"
    end
  end
end