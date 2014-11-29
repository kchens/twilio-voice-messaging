module AppointmentreminderHelper

  # your Twilio authentication credentials
  ACCOUNT_SID = ENV['ACCOUNT_SID']
  ACCOUNT_TOKEN = ENV['ACCOUNT_TOKEN']

  # base URL of this application
  # this is the route we hit to access the api
  # ** need ngrok to test twilio
  # 1) gem 'pow' to test ngrok and backbone on the same wifi
  # 2) test twilio+api and backbone on the same computer
  # "/appointmentreminder/..." = the backbone route
  BASE_URL = "http://2c253d0d.ngrok.com/appointmentreminder"

  # Outgoing Caller ID you have previously validated with Twilio
  CALLER_NUM = '+14083735458'
  def makecall
    unless params['number']
      params['number']
      redirect_to :action => '.', 'msg' => 'Invalid phone number'
      return
    end

    # parameters sent to Twilio REST API
    data = {
      :from => CALLER_NUM,
      :to => params['number'],
      :url => BASE_URL + '/reminder',
    }

    begin
      client = Twilio::REST::Client.new(ACCOUNT_SID, ACCOUNT_TOKEN)
      client.account.calls.create data
    rescue StandardError => bang
      redirect_to :action => '.', 'msg' => "Error #{bang}"
      return
    end

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end


  def reminder
    ## This is user we will customize the message for.
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
