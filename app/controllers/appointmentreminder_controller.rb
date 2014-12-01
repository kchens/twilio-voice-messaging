require 'rubygems'
require "twilio-ruby"
require 'dotenv'

class AppointmentreminderController < ApplicationController

  # your Twilio authentication credentials

  # base URL of this application
  BASE_URL = "http://2c253d0d.ngrok.com/appointmentreminder"

  # Outgoing Caller ID you have previously validated with Twilio
  CALLER_NUM = '+14083735458'

  def index
  end

  # Use the Twilio REST API to initiate an outgoing call
  def makecall
    #Is it a valid phone number?
    unless params['number']
      params['number']
      redirect_to :action => '.', 'msg' => 'Invalid phone number'
      return
    end

    # parameters sent to Twilio REST API
    data = {
      "from" => CALLER_NUM,
      "to" => params['number'],
      "url" => BASE_URL + '/reminder',
    }

    begin

      # client = Twilio::REST::Client.new(ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"])
      # client.account.calls.create data
      p "yolo"
      TwilioWorker.perform_async(data)
      p "solo"
    rescue StandardError => bang
      redirect_to :action => '.', 'msg' => "Error #{bang}"
      return
    end

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def reminder
    puts 'lksajdklfjksldfjkj'
    # @user = User.find_by(number: params[:number])
    @post_to = BASE_URL + '/directions'
    render :action => "reminder.xml.builder", :layout => false
  end

  def directions
    if params['Digits'] == '3'
      redirect_to :action => 'goodbye'
      return
    end

    if !params['Digits'] or params['Digits'] != '2'
      redirect_to :action => 'reminder'
      return
    end

    @redirect_to = BASE_URL + '/reminder'
    render :action => "directions.xml.builder", :layout => false
  end
end
