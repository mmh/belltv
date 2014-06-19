require 'net/http'

@proxy = ""
@currentDir = Dir.pwd
@stripDir = File.join(@currentDir,"assets/images/daily_dilbert")
@stripPattern = @stripDir+"/latest.gif"

def get_strip_url
  proxyURI = URI.parse(@proxy)
  http = Net::HTTP.new('www.dilbert.com', nil, proxyURI.host, proxyURI.port)
  response = http.request(Net::HTTP::Get.new('/fast'))
  response.body.scan(/<img src=\"(\/dyn\/str\_strip\/[\/0-9]*\.strip\.print\.gif)\" \/>/)[0][0] if response and response.body
end

def download_strip(url)
  proxyURI = URI.parse(@proxy)
  file_name = DateTime.now.strftime(@stripPattern)
  Net::HTTP.start('www.dilbert.com', nil, proxyURI.host, proxyURI.port) { |http|
    response = http.get(url)
    open(file_name, "wb") { |file| file.write(response.body) }
  }
  file_name
end

SCHEDULER.every '60m', :first_in => 0 do |job|
  # dilbert
  dilbert_url = get_strip_url
  dilbert_file = download_strip(dilbert_url)
  if not File.exists?(dilbert_file)
    warn "Dilbert strip download failed from url #{dilbert_url} to file #{dilbert_file}"
  end
  send_event('dilbert', { image: "/assets/daily_dilbert/latest.gif" })

  # wumo
  today = DateTime.now.strftime("%Y/%m/%d")  
  wumo_today = "http://kindofnormal.com/img/wumo/" + today + ".jpg"
  url = URI.parse(wumo_today)
  req = Net::HTTP.new(url.host, url.port)
  res = req.request_head(url.path)
  if res.code == "200"
    send_event('wumo', { image: wumo_today })
  else
    send_event('wumo', { image: "http://kindofnormal.com/img/wumo/2014/06/12.jpg" })
  end
end
