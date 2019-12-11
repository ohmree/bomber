#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thread'
require 'socket'
require 'curses'
# require 'msgpack'

# TODO: get initial setup once from
# the server, upon connection
map = Array.new(3, Array.new(3, '~'))

# TODO: maybe keep track of other players?
# We might have to do this

client = UDPSocket.new(Socket::AF_INET)
client.connect('127.0.0.1', 4913)

name = 'animo'
player = { x: 0, y: 0 }
def send_command(sock, cmd)
  sock.send(cmd, 0)
end

send_command(client, "join #{name} 1 1")

loop do
  # Curses.noecho
  # Curses.cursor 0
  case Curses.getch
  when 'q'
    send_command(client, 'exit')
    exit
  when 'a'
    send_command(client, "move #{name} -1  0")
  when 'w'
    send_command(client, "move #{name}  0 -1")
  when 's'
    send_command(client, "move #{name}  0  1")
  when 'd'
    send_command(client, "move #{name}  1  0")
  end
end
# send_command ARGV.map(&:strip).join(' '), 0 unless ARGV.empty?
