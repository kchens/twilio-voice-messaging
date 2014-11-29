xml.instruct!
xml.Response do
    xml.Gather(:action => @post_to, :numDigits => 1) do
        xml.Say "Hello John this is a call from Twilio.  You have an appointment
tomorrow at 9 AM."
    end
end
