SCHEDULER.cron '54 11 * * *' do 
	# Every day at ...
	baconify()
end

SCHEDULER.cron '10 12 * * *' do
	# Every day at ..
	debacon()
end

def baconify()
	send_event('baconify', { value: "baconify" } )
end

def debacon()
	send_event('baconify', { value: "debacon" } )
end
