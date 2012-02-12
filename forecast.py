
"""Retrieve the weather forecast for the current location."""

__author__ = 'Rupert Plumridge <r.plumridge@gmail.com>'
__copyright__ = 'Copyleft (c) 2010, The World.'
__license__ = 'Creative Commons Attribution-Non-Commercial-Share Alike 3.0 Unported Licence'
# based on the weather.py script by T.V. Raman <raman@google.com>,from Google, from the ASE Python script examples


import urllib2, re
from xml.dom import minidom
from urllib import quote

GOOGLE_WEATHER_URL   = 'http://www.google.co.uk/ig/api?weather=%s&hl=%s'

def extract_value(dom, parent, child):
  """Convenience function to dig out weather values."""
  return dom.getElementsByTagName(parent)[0].getElementsByTagName(child)[0].getAttribute('data')

def get_weather_from_google(location_id, hl = ''):
    """
    Fetches weather report from Google

    Parameters 
      location_id: a zip code (10001); city name, state (weather=woodland,PA); city name, country (weather=london, england);
      latitude/longitude(weather=,,,30670000,104019996) or possibly other.
      hl: the language parameter (language code). Default value is empty string, in this case Google will use English.

    Returns:
      weather_data: a dictionary of weather data that exists in XML feed. 
    """
    location_id, hl = map(quote, (location_id, hl))
    url = GOOGLE_WEATHER_URL % (location_id, hl)
    handler = urllib2.urlopen(url)
    content_type = handler.info().dict['content-type']
    xml_response = handler.read()
    dom = minidom.parseString(xml_response)    
    handler.close()
    #some shenanigans to get to the first forecast
    dom1Node = dom.firstChild
    dom2Node = dom1Node.firstChild
    #current conditions    
    current = dom2Node.childNodes[1]
    #next forecast 
    forecast = dom2Node.childNodes[2]
    
    
    #return the data back
    data = {}
    current_dom = dom.getElementsByTagName('weather')[0]
    data['city'] = extract_value(current_dom, 'forecast_information','city')
    data['fdate'] = extract_value(current_dom, 'forecast_information','forecast_date')
    data['ccondition'] = current.getElementsByTagName('condition')[0].getAttribute('data')
    data['ctemp'] = current.getElementsByTagName('temp_c')[0].getAttribute('data')
    data['cwind'] = current.getElementsByTagName('wind_condition')[0].getAttribute('data')
    data['fcondition'] = forecast.getElementsByTagName('condition')[0].getAttribute('data')
    data['flow'] = forecast.getElementsByTagName('low')[0].getAttribute('data')
    data['fhigh'] = forecast.getElementsByTagName('high')[0].getAttribute('data')
    data['fday'] = forecast.getElementsByTagName('day_of_week')[0].getAttribute('data')
    dom.unlink()
    return data
