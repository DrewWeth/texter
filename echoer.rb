require 'logger'
require 'twilio-ruby'
require 'json'
require 'net/http'

log_file = File.open('./stdout.log', "a")
$logger = Logger.new(log_file)

class Device
	attr_accessor :name, :tele
	def initialize(name, tele)
		@name = name
		@tele = tele
	end
end

$copy = Device.new("Drew", "+13147759588")

def send_text(device, message)
	# Message composition

	account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
	auth_token = '77d93608f97102a6011bb3fd90229a85'
	begin
		@client = Twilio::REST::Client.new account_sid, auth_token
	rescue Twilio::RESR::RequestError => e
		$logger.error("Error with Twilio client. #{e.message}")
		return false
	end

	begin
		@client.account.messages.create(
		:from => '+13147363270',
		:to => device.tele,
		:body => message)

		# raise "An error!"
		$logger.info("Sent text to: #{instance_var(device)} with content: #{message}")
		return true
	rescue Exception => e
		$logger.error("Error sending text to #{instance_var(device)} with content: #{message}. #{e}")
		return false
	end
	return false
end

def instance_var(obj)
	hash = {}
	obj.instance_variables.each do |e|
		hash[e] = obj.instance_variable_get(e)
	end
	return hash
end

def query_db()
	begin
		uri = URI("http://localhost:3000/messages/sample")
		res = Net::HTTP.post_form(uri, Hash.new)
		return res.body
	rescue Exception => e
		$logger.warn("Couldn't connect to localhost: #{e}")
	end
	$logger.warn("No response.")
	return Hash.new
end

def send_message(message)
	# recip = Device.new("Maggie", "+19136697670")
	recip = Device.new("Drew", "+13147759588")
	if send_text(recip, message)
		send_text($copy, "INFO: #{message} was sent to #{instance_var(recip)}")
	else
		send_text($copy, "ERROR: #{message} was not sent to #{instance_var(recip)}")
	end
end

db_result = query_db()
if db_result != "null" and data = JSON.parse(db_result)
	puts "DB result: #{db_result}"
	send_message(data["content"])
else
	send_message("Good morning!")
end
# puts db_result
