require 'yaml'

class TransApiController < ApplicationController
  def index
    puts 'TEXT: [' + params['text'] + ']'

    if params['text'] != nil then
      text = params['text']
    else
      text = '良い旅を！'
    end

    if ENV['CONSUMER_KEY'].nil?
      setting = YAML.load_file("app/secret/setting/apikey.yml")

      consumer_key = setting['CONSUMER_KEY']
      consumer_secret = setting['CONSUMER_SECRET']
      url = setting['URL']
      name = setting['NAME']
    else
      consumer_key = ENV['CONSUMER_KEY']
      consumer_secret = ENV['CONSUMER_SECRET']
      url = ENV['URL']
      name = ENV['NAME']
    end

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret)
    endpoint = OAuth::AccessToken.new(consumer)

    begin
      response = endpoint.post(url,{key: consumer_key,type: 'json',name: name, text: text})
      
      puts response.body
      render json: response.body
      
    rescue Timeout::Error => e
      puts '>>>TIMEOUT<<<'
      p e
      render json: {"resultset":{"code":-1, "message":"timeout"}}
    rescue => exception
      p exception
      render json: {"resultset":{"code":-1, "message":"error"}}
    end
  end
end
