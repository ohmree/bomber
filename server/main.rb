#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thread'
require 'socket'
# require 'msgpack'

def parse_command(msg)
  full_command = msg.split
  command = full_command.first
  parameters = full_command[1..]

  [command, parameters]
end

def move(players, name, x, y)
  players[name][:x] += x.to_i
  players[name][:y] += y.to_i
end

server = UDPSocket.new(Socket::AF_INET)
server.bind('127.0.0.1', 4913)
password = 1234

map = Array.new(3, Array.new(3, '~'))
players = {}

loop do
  unless players.empty?
    players.each do |name, pos|
      map[pos[:x]][pos[:y]] = '@'
    end
  end
  message, sender_info = server.recvfrom(10)
  # FIXME: order of {from,to}_ip might be wrong. Doesnt matter for now
  # UDP sender info
  family, _, from_ip, to_ip = sender_info


  cmd, params = parse_command(message)
  case cmd
  when 'join'
    puts 'join'
    next if params.empty?
    players[params[0]] = { x: params[1].to_i, y: params[2].to_i }
    puts "#{params[0]} #{params[1]}"
    puts "#{players['animo'][:x]} #{players['animo'][:y]}"
  when 'exit'
    exit params[0].to_i || 0
  when 'pass'
    # TODO: maybe communicate an error to the client
    next if params.empty?

    if params[0].to_i == password
      puts 'The password is correct!'
    else
      puts 'Incorrect password'
    end
  when 'move'
    # TODO: implement this
    move(players, params[0], params[1], params[2])
  else
    # TODO: communicate the error to the
    # client when message is not a valid command
  end

  # TODO: figure out if sleeping is needed
  # sleep 1
  map.each do |col|
    puts col.join
  end

  unless players.empty?
    players.each do |name, pos|
      map[pos[:x]][pos[:y]] = '~'
    end
  end

end
