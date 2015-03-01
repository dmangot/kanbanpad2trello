#!/usr/bin/env ruby

require 'httparty'
require 'json'
require 'trello'


class Kanbanpad
  include HTTParty
  base_uri 'https://www.kanbanpad.com/api/v1/'

  @@kbp_username = 'XXXX'
  @@kbp_token    = 'XXXX'

  def initialize
    @auth = { username: @@kbp_username, password: @@kbp_token }
  end

  def projects
    self.class.get('/projects.json', { :basic_auth => @auth })
  end

  def steps(slug)
    self.class.get("/projects/#{slug}/steps.json", { :basic_auth => @auth })
  end

  def tasks(slug,id)
    self.class.get("/projects/#{slug}/steps/#{id}/tasks.json", { :basic_auth => @auth })
  end

  def comments(slug,id)
    self.class.get("/projects/#{slug}/tasks/#{id}/comments.json", { :basic_auth => @auth })
  end

end


trello_key   = 'XXXX'
trello_token = 'XXXX'
Trello.configure do |trello|
  trello.developer_public_key = trello_key
  trello.member_token = trello_token
end

kbp = Kanbanpad.new

# Kanbanpad: projects -> steps -> tasks
# Trello: boards -> lists -> cards
parsed_kbp = JSON.parse(kbp.projects.body)
parsed_kbp.each do |projects|
  puts "*****\nProject name: #{projects['name']}" 
  board = Trello::Board.create( name: projects['name'] )
  board.lists.each do |list| 
    list.close!
  end
  parsed_steps = JSON.parse(kbp.steps(projects['slug']).body)
  parsed_steps.reverse.each do |steps|
    puts "Step name: #{steps['name']}"
    list = Trello::List.create( name: steps['name'], board_id: board.id)    
    parsed_tasks = JSON.parse(kbp.tasks(projects['slug'],steps['id']).body)
    parsed_tasks.each do |tasks|
      puts tasks['title']
      card = Trello::Card.create( name: tasks['title'], list_id: list.id )
      if (tasks['comments_total'].to_i != 0)
        parsed_comments = JSON.parse(kbp.comments(projects['slug'],tasks['id']).body)
        parsed_comments.each do |comment|
          puts "Comment => #{comment['body']}"
          card.add_comment(comment['body'])
        end
      end
    end
  end
end


#puts kbp.projects
#puts response.body, response.code, response.message, response.headers.inspect
