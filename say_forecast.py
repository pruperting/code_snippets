"""Speak the weather forecast."""

__author__ = 'Rupert Plumridge <r.plumridge@gmail.com>'
__copyright__ = 'Copyleft (c) 2010, The World.'
__license__ = 'Creative Commons Attribution-Non-Commercial-Share Alike 3.0 Unported Licence'
# based on the say_weather.py script by T.V. Raman <raman@google.com>,from Google, from the ASE Python script examples

import android
import forecast

def say_weather(droid):
  """Speak the weather at the current location."""
  print 'Finding ZIP code.'
  location = droid.getLastKnownLocation().result
  addresses = droid.geocode(location['latitude'], location['longitude'])
  zip = addresses.result[0]['postal_code']
  if zip is None:
    msg = 'Failed to find location.'
  else:
    print 'Fetching weather report.'
    result = forecast.get_weather_from_google(zip)
    # Format the result for speech.
    msg = 'On %(fdate)s %(city)s is %(ccondition)s %(ctemp)s degrees and %(cwind)s %(fday)s forecast is %(fcondition)s from %(flow)s to %(fhigh)s fahrenheit.' % result
  droid.speak(msg)


if __name__ == '__main__':
  droid = android.Android()
  say_weather(droid)

#notification, to be implemented when I get a chance
#  droid.notify(msg, 'Weather Report', msg)
#  droid.exit()

