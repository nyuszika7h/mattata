local dns = {}
local mattata = require('mattata')
local HTTP = require('socket.http')
local JSON = require('dkjson')

function dns:init(configuration)
	dns.arguments = 'dns <URL> <type>'
	dns.commands = mattata.commands(self.info.username, configuration.commandPrefix):c('dns').table
	dns.help = configuration.commandPrefix .. 'dns <URL> <type> - Sends DNS records of the given type for the given URL. The types currently supported are AAAA, A, CERT, CNAME, DLV, IPSECKEY, MX, NS, PTR, SIG, SRV and TXT. Returns a maximum of 5 records for the given type.'
end

function dns:onMessageReceive(msg, configuration)
	local input = mattata.input(msg.text_lower)
	if not input then
		mattata.sendMessage(msg.chat.id, dns.help, nil, true, false, msg.message_id, nil)
		return
	end
	local jstr, res = HTTP.request('http://dig.jsondns.org/IN/' .. input:gsub(' ', '/'))
	local jdat = JSON.decode(jstr)
	if jdat.header.rcode == 'NOERROR' then
		local output
		if string.match(input, ' aaaa') or string.match(input, ' a') or string.match(input, ' ns') or string.match(input, ' txt') then
			if jdat.answer[1] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata .. '`'
			end
			if jdat.answer[2] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata .. '`'
			end
			if jdat.answer[3] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata .. '\n\nName: ' .. jdat.answer[3].name .. '\nType: ' .. jdat.answer[3].type .. '\nClass: ' .. jdat.answer[3].class .. '\nTTL: ' .. jdat.answer[3].ttl .. '\nRData: ' .. jdat.answer[3].rdata .. '`'
			end
			if jdat.answer[4] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata .. '\n\nName: ' .. jdat.answer[3].name .. '\nType: ' .. jdat.answer[3].type .. '\nClass: ' .. jdat.answer[3].class .. '\nTTL: ' .. jdat.answer[3].ttl .. '\nRData: ' .. jdat.answer[3].rdata .. '\n\nName: ' .. jdat.answer[4].name .. '\nType: ' .. jdat.answer[4].type .. '\nClass: ' .. jdat.answer[4].class .. '\nTTL: ' .. jdat.answer[4].ttl .. '\nRData: ' .. jdat.answer[4].rdata .. '`'
			end
			if jdat.answer[5] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata .. '\n\nName: ' .. jdat.answer[3].name .. '\nType: ' .. jdat.answer[3].type .. '\nClass: ' .. jdat.answer[3].class .. '\nTTL: ' .. jdat.answer[3].ttl .. '\nRData: ' .. jdat.answer[3].rdata .. '\n\nName: ' .. jdat.answer[4].name .. '\nType: ' .. jdat.answer[4].type .. '\nClass: ' .. jdat.answer[4].class .. '\nTTL: ' .. jdat.answer[4].ttl .. '\nRData: ' .. jdat.answer[4].rdata .. '\n\nName: ' .. jdat.answer[5].name .. '\nType: ' .. jdat.answer[5].type .. '\nClass: ' .. jdat.answer[5].class .. '\nTTL: ' .. jdat.answer[5].ttl .. '\nRData: ' .. jdat.answer[5].rdata .. '`'
			end
			mattata.sendMessage(msg.chat.id, output, 'Markdown', true, false, msg.message_id, nil)
			return
		end
		if string.match(input, ' cert') or string.match(input, ' cname') then
			if jdat.authority[1] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. '`'
			end
			if jdat.authority[2] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. '`'
			end
			if jdat.authority[3] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. '\n\nName: ' .. jdat.authority[3].name .. '\nType: ' .. jdat.authority[3].type .. '\nClass: ' .. jdat.authority[3].class .. '\nTTL: ' .. jdat.authority[3].ttl .. '\nRData: ' .. jdat.authority[3].rdata[1] .. ', ' .. jdat.authority[3].rdata[2] .. ', ' .. jdat.authority[3].rdata[3] .. ', ' .. jdat.authority[3].rdata[4] .. ', ' .. jdat.authority[3].rdata[5] .. ', ' .. jdat.authority[3].rdata[6] .. '`'
			end
			if jdat.authority[4] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. '\n\nName: ' .. jdat.authority[3].name .. '\nType: ' .. jdat.authority[3].type .. '\nClass: ' .. jdat.authority[3].class .. '\nTTL: ' .. jdat.authority[3].ttl .. '\nRData: ' .. jdat.authority[3].rdata[1] .. ', ' .. jdat.authority[3].rdata[2] .. ', ' .. jdat.authority[3].rdata[3] .. ', ' .. jdat.authority[3].rdata[4] .. ', ' .. jdat.authority[3].rdata[5] .. ', ' .. jdat.authority[3].rdata[6] .. '\n\nName: ' .. jdat.authority[4].name .. '\nType: ' .. jdat.authority[4].type .. '\nClass: ' .. jdat.authority[4].class .. '\nTTL: ' .. jdat.authority[4].ttl .. '\nRData: ' .. jdat.authority[4].rdata[1] .. ', ' .. jdat.authority[4].rdata[2] .. ', ' .. jdat.authority[4].rdata[3] .. ', ' .. jdat.authority[4].rdata[4] .. ', ' .. jdat.authority[4].rdata[5] .. ', ' .. jdat.authority[4].rdata[6] .. '`'
			end
			if jdat.authority[5] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. '\n\nName: ' .. jdat.authority[3].name .. '\nType: ' .. jdat.authority[3].type .. '\nClass: ' .. jdat.authority[3].class .. '\nTTL: ' .. jdat.authority[3].ttl .. '\nRData: ' .. jdat.authority[3].rdata[1] .. ', ' .. jdat.authority[3].rdata[2] .. ', ' .. jdat.authority[3].rdata[3] .. ', ' .. jdat.authority[3].rdata[4] .. ', ' .. jdat.authority[3].rdata[5] .. ', ' .. jdat.authority[3].rdata[6] .. '\n\nName: ' .. jdat.authority[4].name .. '\nType: ' .. jdat.authority[4].type .. '\nClass: ' .. jdat.authority[4].class .. '\nTTL: ' .. jdat.authority[4].ttl .. '\nRData: ' .. jdat.authority[4].rdata[1] .. ', ' .. jdat.authority[4].rdata[2] .. ', ' .. jdat.authority[4].rdata[3] .. ', ' .. jdat.authority[4].rdata[4] .. ', ' .. jdat.authority[4].rdata[5] .. ', ' .. jdat.authority[4].rdata[6] .. '\n\nName: ' .. jdat.authority[5].name .. '\nType: ' .. jdat.authority[5].type .. '\nClass: ' .. jdat.authority[5].class .. '\nTTL: ' .. jdat.authority[5].ttl .. '\nRData: ' .. jdat.authority[5].rdata[1] .. ', ' .. jdat.authority[5].rdata[2] .. ', ' .. jdat.authority[5].rdata[3] .. ', ' .. jdat.authority[5].rdata[4] .. ', ' .. jdat.authority[5].rdata[5] .. ', ' .. jdat.authority[5].rdata[6] .. '`'
			end
			mattata.sendMessage(msg.chat.id, output, 'Markdown', true, false, msg.message_id, nil)
			return
		end
		if string.match(input, ' mx') then
			if jdat.answer[1] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata[1] .. ', ' .. jdat.answer[1].rdata[2] .. '`'
			end
			if jdat.answer[2] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata[1] .. ', ' .. jdat.answer[1].rdata[2] .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata[1] .. ', ' .. jdat.answer[2].rdata[2] .. '`'
			end
			if jdat.answer[3] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata[1] .. ', ' .. jdat.answer[1].rdata[2] .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata[1] .. ', ' .. jdat.answer[2].rdata[2] .. '\n\nName: ' .. jdat.answer[3].name .. '\nType: ' .. jdat.answer[3].type .. '\nClass: ' .. jdat.answer[3].class .. '\nTTL: ' .. jdat.answer[3].ttl .. '\nRData: ' .. jdat.answer[3].rdata[1] .. ', ' .. jdat.answer[3].rdata[2] .. '`'
			end
			if jdat.answer[4] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata[1] .. ', ' .. jdat.answer[1].rdata[2] .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata[1] .. ', ' .. jdat.answer[2].rdata[2] .. '\n\nName: ' .. jdat.answer[3].name .. '\nType: ' .. jdat.answer[3].type .. '\nClass: ' .. jdat.answer[3].class .. '\nTTL: ' .. jdat.answer[3].ttl .. '\nRData: ' .. jdat.answer[3].rdata[1] .. ', ' .. jdat.answer[3].rdata[2] .. '\n\nName: ' .. jdat.answer[4].name .. '\nType: ' .. jdat.answer[4].type .. '\nClass: ' .. jdat.answer[4].class .. '\nTTL: ' .. jdat.answer[4].ttl .. '\nRData: ' .. jdat.answer[4].rdata[1] .. ', ' .. jdat.answer[4].rdata[2] .. '`'
			end
			if jdat.answer[5] then
				output = '`Name: ' .. jdat.answer[1].name .. '\nType: ' .. jdat.answer[1].type .. '\nClass: ' .. jdat.answer[1].class .. '\nTTL: ' .. jdat.answer[1].ttl .. '\nRData: ' .. jdat.answer[1].rdata[1] .. ', ' .. jdat.answer[1].rdata[2] .. '\n\nName: ' .. jdat.answer[2].name .. '\nType: ' .. jdat.answer[2].type .. '\nClass: ' .. jdat.answer[2].class .. '\nTTL: ' .. jdat.answer[2].ttl .. '\nRData: ' .. jdat.answer[2].rdata[1] .. ', ' .. jdat.answer[2].rdata[2] .. '\n\nName: ' .. jdat.answer[3].name .. '\nType: ' .. jdat.answer[3].type .. '\nClass: ' .. jdat.answer[3].class .. '\nTTL: ' .. jdat.answer[3].ttl .. '\nRData: ' .. jdat.answer[3].rdata[1] .. ', ' .. jdat.answer[3].rdata[2] .. '\n\nName: ' .. jdat.answer[4].name .. '\nType: ' .. jdat.answer[4].type .. '\nClass: ' .. jdat.answer[4].class .. '\nTTL: ' .. jdat.answer[4].ttl .. '\nRData: ' .. jdat.answer[4].rdata[1] .. ', ' .. jdat.answer[4].rdata[2] .. '\n\nName: ' .. jdat.answer[5].name .. '\nType: ' .. jdat.answer[5].type .. '\nClass: ' .. jdat.answer[5].class .. '\nTTL: ' .. jdat.answer[5].ttl .. '\nRData: ' .. jdat.answer[5].rdata[1] .. ', ' .. jdat.answer[5].rdata[2] .. '`'
			end
			mattata.sendMessage(msg.chat.id, output, 'Markdown', true, false, msg.message_id, nil)
			return
		end
		if string.match(input, ' srv') or string.match(input, ' ipseckey') or string.match(input, ' ptr') or string.match(input, ' sig') or string.match(input, ' dlv') then
			if jdat.authority[1] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. ', ' .. jdat.authority[1].rdata[7] .. '`'
			end
			if jdat.authority[2] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. ', ' .. jdat.authority[1].rdata[7] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. ', ' .. jdat.authority[2].rdata[7] .. '`'
			end
			if jdat.authority[3] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. ', ' .. jdat.authority[1].rdata[7] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. ', ' .. jdat.authority[2].rdata[7] .. '\n\nName: ' .. jdat.authority[3].name .. '\nType: ' .. jdat.authority[3].type .. '\nClass: ' .. jdat.authority[3].class .. '\nTTL: ' .. jdat.authority[3].ttl .. '\nRData: ' .. jdat.authority[3].rdata[1] .. ', ' .. jdat.authority[3].rdata[2] .. ', ' .. jdat.authority[3].rdata[3] .. ', ' .. jdat.authority[3].rdata[4] .. ', ' .. jdat.authority[3].rdata[5] .. ', ' .. jdat.authority[3].rdata[6] .. ', ' .. jdat.authority[3].rdata[7] .. '`'
			end
			if jdat.authority[4] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. ', ' .. jdat.authority[1].rdata[7] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. ', ' .. jdat.authority[2].rdata[7] .. '\n\nName: ' .. jdat.authority[3].name .. '\nType: ' .. jdat.authority[3].type .. '\nClass: ' .. jdat.authority[3].class .. '\nTTL: ' .. jdat.authority[3].ttl .. '\nRData: ' .. jdat.authority[3].rdata[1] .. ', ' .. jdat.authority[3].rdata[2] .. ', ' .. jdat.authority[3].rdata[3] .. ', ' .. jdat.authority[3].rdata[4] .. ', ' .. jdat.authority[3].rdata[5] .. ', ' .. jdat.authority[3].rdata[6] .. ', ' .. jdat.authority[3].rdata[7] .. '\n\nName: ' .. jdat.authority[4].name .. '\nType: ' .. jdat.authority[4].type .. '\nClass: ' .. jdat.authority[4].class .. '\nTTL: ' .. jdat.authority[4].ttl .. '\nRData: ' .. jdat.authority[4].rdata[1] .. ', ' .. jdat.authority[4].rdata[2] .. ', ' .. jdat.authority[4].rdata[3] .. ', ' .. jdat.authority[4].rdata[4] .. ', ' .. jdat.authority[4].rdata[5] .. ', ' .. jdat.authority[4].rdata[6] .. ', ' .. jdat.authority[4].rdata[7] .. '`'
			end
			if jdat.authority[5] then
				output = '`Name: ' .. jdat.authority[1].name .. '\nType: ' .. jdat.authority[1].type .. '\nClass: ' .. jdat.authority[1].class .. '\nTTL: ' .. jdat.authority[1].ttl .. '\nRData: ' .. jdat.authority[1].rdata[1] .. ', ' .. jdat.authority[1].rdata[2] .. ', ' .. jdat.authority[1].rdata[3] .. ', ' .. jdat.authority[1].rdata[4] .. ', ' .. jdat.authority[1].rdata[5] .. ', ' .. jdat.authority[1].rdata[6] .. ', ' .. jdat.authority[1].rdata[7] .. '\n\nName: ' .. jdat.authority[2].name .. '\nType: ' .. jdat.authority[2].type .. '\nClass: ' .. jdat.authority[2].class .. '\nTTL: ' .. jdat.authority[2].ttl .. '\nRData: ' .. jdat.authority[2].rdata[1] .. ', ' .. jdat.authority[2].rdata[2] .. ', ' .. jdat.authority[2].rdata[3] .. ', ' .. jdat.authority[2].rdata[4] .. ', ' .. jdat.authority[2].rdata[5] .. ', ' .. jdat.authority[2].rdata[6] .. ', ' .. jdat.authority[2].rdata[7] .. '\n\nName: ' .. jdat.authority[3].name .. '\nType: ' .. jdat.authority[3].type .. '\nClass: ' .. jdat.authority[3].class .. '\nTTL: ' .. jdat.authority[3].ttl .. '\nRData: ' .. jdat.authority[3].rdata[1] .. ', ' .. jdat.authority[3].rdata[2] .. ', ' .. jdat.authority[3].rdata[3] .. ', ' .. jdat.authority[3].rdata[4] .. ', ' .. jdat.authority[3].rdata[5] .. ', ' .. jdat.authority[3].rdata[6] .. ', ' .. jdat.authority[3].rdata[7] .. '\n\nName: ' .. jdat.authority[4].name .. '\nType: ' .. jdat.authority[4].type .. '\nClass: ' .. jdat.authority[4].class .. '\nTTL: ' .. jdat.authority[4].ttl .. '\nRData: ' .. jdat.authority[4].rdata[1] .. ', ' .. jdat.authority[4].rdata[2] .. ', ' .. jdat.authority[4].rdata[3] .. ', ' .. jdat.authority[4].rdata[4] .. ', ' .. jdat.authority[4].rdata[5] .. ', ' .. jdat.authority[4].rdata[6] .. ', ' .. jdat.authority[4].rdata[7] .. '\n\nName: ' .. jdat.authority[5].name .. '\nType: ' .. jdat.authority[5].type .. '\nClass: ' .. jdat.authority[5].class .. '\nTTL: ' .. jdat.authority[5].ttl .. '\nRData: ' .. jdat.authority[5].rdata[1] .. ', ' .. jdat.authority[5].rdata[2] .. ', ' .. jdat.authority[5].rdata[3] .. ', ' .. jdat.authority[5].rdata[4] .. ', ' .. jdat.authority[5].rdata[5] .. ', ' .. jdat.authority[5].rdata[6] .. ', ' .. jdat.authority[5].rdata[7] .. '`'
			end
			mattata.sendMessage(msg.chat.id, output, 'Markdown', true, false, msg.message_id, nil)
			return
		end
	else
		mattata.sendMessage(msg.chat.id, configuration.errors.results, nil, true, false, msg.message_id, nil)
		return
	end
end

return dns