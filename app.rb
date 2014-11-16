require 'sinatra'
require 'json'

def test_text(user_code, klass_name, cases)
  puts "cases", cases
  cases_string = cases.map(&:to_s).join(',')
"""
require 'rspec/autorun'

#{user_code}

def do_testing(klass, cases)
  describe klass do
    cases.each do |kase|
      it kase['name'] do
        expect(eval(kase['code'])).to be_true
      end
    end
  end
end

do_testing(#{klass_name}, [#{cases_string}])
"""
end

post '/' do
  body = JSON.parse(request.body.read)
  test_text(body["user_code"], body["class_name"], body["cases"])
end
