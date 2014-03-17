SCHEDULER.every '60m', :first_in => 0 do |job|
  today = DateTime.now.strftime("%Y/%m/%d")  
  wumo_today = "http://kindofnormal.com/img/wumo/" + today + ".jpg"
  send_event('wumo', { image: wumo_today })
end
