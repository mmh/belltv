require 'elasticsearch'
require 'hashie'

SCHEDULER.every '1m', :first_in => 0 do |job|
  
  # Connect to cluster at search1:9200, sniff all nodes and round-robin between them
  es = Elasticsearch::Client.new host: 'logstash.bellcom.dk'
  
  today = Time.now.strftime("%Y.%m.%d")
  yesterday = Date.today.prev_day.strftime("%Y.%m.%d")
  
  
  response = es.search index: 'logstash-' + today + ',logstash-' + yesterday,
            body: { query: { match: { host: '192.168.1.11' } }, size: 5, sort: [ { "@timestamp" => 'desc' } ] }
  
  mash = Hashie::Mash.new response
  data = [];
  date_and_time = '%Y-%m-%d %H:%M:%S %Z'
  color = "blue"

  mash.hits.hits.each do |result|
        x = DateTime.strptime(result._source.received_at,date_and_time)
        # quick way to add 2 hours :)
        x = x + Rational(60*60*2, 86400)
        case result._source.syslog_pri
        when "130"
          color = "red"
        when "132"
          color = "yellow"
        when "133"
          color = "#19FF19"
        when "134"
          color = "black"
        end
        data.push({
          label: x.strftime("%F %T"),
          value: "<span style=color:" + color + ">" + result._source[:@message] + "</span>"
        });
  end
  
  send_event('ctslog', { items: data })

end
