require 'logger'
require 'twilio-ruby'


log_file = File.open('./stdout.log', "a")
logger = Logger.new(log_file)
	

class Device
	attr_accessor :name, :tele
	def initialize(name, tele)
		@name = name
		@tele = tele
	end
end

def send_text(device, message)
	# Message composition

	account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
	auth_token = '77d93608f97102a6011bb3fd90229a85'
	begin
		@client = Twilio::REST::Client.new account_sid, auth_token
	rescue Twilio::RESR::RequestError => e
		puts e.message
	end

	begin
		@client.account.messages.create(
		:from => '+13147363270',
		:to => device.tele,
		:body => message
		)
		return true
	rescue Exception => e
		puts e
	end
	return false
end

mags = Device.new("Maggie", "+19136697670")


if send_text(mags, "Good morning #{mags.name}!")
	logger.info("Sent text to: #{mags.inspect}")
else
	logger.error("Error sending text to #{mags.inspect}")
end
