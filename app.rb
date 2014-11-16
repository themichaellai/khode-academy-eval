require 'sinatra'
require 'json'
require 'shellwords'

def test_text(user_code, klass_name, cases)
  puts "cases", cases
  cases_string = cases.map(&:to_s).join(',')
"""
require 'rspec/autorun'

#{user_code}

def do_testing(cases)
  describe \"Test\" do
    cases.each do |kase|
      it kase['name'] do
        if kase['test_type'].eql? 'expect'
          expect(eval(kase['arg_a']).to_s).to eql(kase['arg_b'].to_s)
        end
      end
    end
  end
end

puts 'TEST CASES'
do_testing([#{cases_string}])
"""
end

get '/' do
  'khode academy'
end

post '/' do
  body = JSON.parse(request.body.read)
  test_program = test_text(body["user_code"], body["class_name"], body["cases"])
  puts test_program
  `ruby -e #{Shellwords.escape(test_program)}`
end
