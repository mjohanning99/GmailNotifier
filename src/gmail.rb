require 'serialport'
require 'gmail'

#Start the bash file, read the file it creates and find out what port the Arduino is connected to
system("bash #{File.dirname(__FILE__)}/detect_serial.sh > serial")
File.open("#{File.dirname(__FILE__)}/serial").each_line do |line|
   @serial_connection = line.slice(0..(line.index(' '))) if line.include?("Arduino")
end

#Gmail username and password
gmail = Gmail.connect("manimusmuellus", "crnlofqszgfysjne")

#count the number of unread messages
prev_unread = gmail.inbox.count(:unread)

#Serial port of the Arduino
puts "Arduino is connected to: #{@serial_connection}"
port_file = @serial_connection.gsub(' ', '')

#this must be same as the baud rate set on the Arduino
#with Serial.begin
baud_rate = 9600

data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

#create a SerialPort object using each of the bits of information
port = SerialPort.new(port_file, baud_rate, data_bits, stop_bits, parity)

wait_time = 4

#for an infinite amount of time
loop do
  #get the number of unread messages in the inbox
  unread = gmail.inbox.count(:unread)

  #lets us know that we've checked the unread messages
  puts "Checked unread."

  #check if the number of unread messages has increased
  if unread > prev_unread
    #Write the subject of the last unread email to the serial port
    port.write gmail.inbox.find(:unread).last.subject

    #For debugging purposes
    puts "Received email: \n" + gmail.inbox.find(:unread).last.subject
  end

  #reset the number of unread emails
  prev_unread = unread

  #wait before we make another request to the Gmail servers
  sleep wait_time
end
