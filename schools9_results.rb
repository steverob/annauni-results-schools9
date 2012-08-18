require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

reg_nos=Array.new
puts "Anna University Results Downloader for schools9.com"
puts "Author: Steve Robinson, Panimalar Institute of Technology"

puts "\n\n"
puts "Please provide the URL of the results"
puts "Follow Below steps to obtain URL"
puts "1. Open the schools9 website and browse to the required results page"
puts "2. Copy the url"
puts "3. Paste URL here and press 'RETURN' key"
url=STDIN.gets.chomp
puts "4. Enter the extension of the results page:"
puts "For example if the url is http://www.schools9.com/annagrade1808.htm"
puts "Then the extension is 'htm'. Please Enter your extension now"
ext=gets.chomp

url="#{url.chomp(ext)}aspx"

puts "The new URL is #{url}"

#URL Processing

puts "================================================"
puts "Note: please provide ONLY CONSECUTIVE register numbers!!!"
puts "================================================"


puts "Enter starting reg no"
start=gets.chomp.to_i
puts "Enter ending reg no"
ending=gets.chomp.to_i
reg=start
while reg!=ending+1
  reg_nos<< reg
  reg+=1
end
puts "Enter file name to store results"
filename=gets.chomp

CSV.open("#{filename}.csv", "wb") do |csv|

reg_nos.each  do |reg_no|


	  doc=Nokogiri::HTML(open("#{url}?htno=#{reg_no}"))
	  cells=doc.css("td")
	  row=""
	  len=cells.length

    len.times do |i|

      if cells[i].text==" Hall Ticket No "
         next
      elsif cells[i-1].text==" Hall Ticket No "
        next
      elsif cells[i].text==" Name "
        row=""
        row="#{cells[i-1].text},'#{cells[i+1].text}'"
        csv << ["#{cells[i-1].text}","'#{cells[i+1].text}'"]
        row=""
        next
      elsif cells[i].text==" Course " || cells[i].text=="B.E. Computer Science and Engineering" || cells[i].text=="Marks Details"  || cells[i].text=="Subject" || cells[i].text=="Grade" || cells[i].text=="Status"
       # puts i
        next
      elsif cells[i].text=="PASS" ||   cells[i].text=="RA" ||   cells[i].text=="A"||   cells[i].text=="B"||   cells[i].text=="C"||   cells[i].text=="D"||   cells[i].text=="E"||   cells[i].text=="S"||   cells[i].text=="U"||   cells[i].text=~ /WH(.*)/ ||   cells[i].text=="AB"||   cells[i].text=="W"||   cells[i].text=="SA" ||   cells[i].text=="SE"||   cells[i].text=="A.B"||   cells[i].text=="I"||   cells[i].text=="WD"||   cells[i].text==" "
        next
      elsif cells[i+1].text==" Course "
        next
      else
        row=""
        row="'#{cells[i].text}','#{cells[i+1].text}','#{cells[i+2].text}'"
        puts row
        csv<< ["'#{cells[i].text}'","'#{cells[i+1].text}'","'#{cells[i+2].text}'"]
        row=""
      end
    end
    csv<< [",",",",","]
end
end

puts "Results saved in '#{filename}.csv'. You can import this file into Excel or any other spreadsheet software"
puts "================================================"
puts "Thanks for using!"
puts "For more of my stuff goto github.com/steverob"
puts "Follow me on twitter @stev4nity"
