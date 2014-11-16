require 'sinatra'
require 'sicuro'

post '/' do
  s = Sicuro.new
  res = s.eval(params[:code])
  "#{res.stderr}\n#{res.stdout}"
end
