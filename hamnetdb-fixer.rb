f = File.read(ARGV[0])
# clean out windows / old mac newlines that are mixed in
f.gsub!("\r", "")

records = []
main_zone_found = false
f.lines.each do |line|
  if line.match? /^\s+$/
    next
  end
  unless main_zone_found
    records << line
    if line.match? /^\$ORIGIN hamnet\.radio\./
      main_zone_found = true
    end
    next
  end
  data = line.scan /(\S+)\s+(\S+)\s+(\S+)\s+(.*)/
  if data.is_a? Array and not data.empty?
    records << data[0]
  end
end

a_and_aaaa_records = records.filter {|fi| fi.is_a?(Array) && (fi[2] == 'A' || fi[2] == 'AAAA') }.map {|fi| fi[0]}

# remove CNAME records where a we have A or an AAAA record
records.delete_if { |fi| fi.is_a?(Array) && fi[2] == 'CNAME' && a_and_aaaa_records.include?(fi[0]) }

# remove duplicate CNAME records
already_known_records = []
records.delete_if do |fi|
  if fi.is_a?(Array) && fi[2] == 'CNAME'
    if already_known_records.include?(fi[0])
      true
    else
      already_known_records << fi[0]
      false
    end
  end
end

File.open(ARGV[0], 'w') do |w|
  records.each do |record|
    if record.is_a? Array
      w << record.join(" ") + "\n"
    elsif record.is_a? String
      w << record
    end
  end
end