local mod = Chatter:NewModule("Chat Autolog")

function mod:OnEnable()
	self.isLogging = LoggingChat()
	LoggingChat(true)
end

function mod:OnDisable()
	LoggingChat(self.isLogging)
end

function mod:Info()
	return "Automatically turns on chat logging."
end
