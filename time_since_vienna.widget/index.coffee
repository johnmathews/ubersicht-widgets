# Time Since widget for Übersicht by John Mathews (github.com/johnmathews/time_since)
# Enter the date and time you want to measure from on line 5
#
# Built from the Fuzzy Time widget by Ruurd Pels (github.com/ruurd/justthedate) 
# and the SideBar widget created by Jonathan MacQueen (https://github.com/jmacqueen) 
# and then Pe8er (https://github.com/Pe8er)

options =
  # Set the start date to count from.
  theDate     : "16/1/2016 22:13"
  # Set the opening and closing phrase
  startPhrase : "Vienna:"    
  endPhrase   : " - Woohoo!!"
  shorten     : "True"  # Must be "True" for abreviations 
  
options : options

# Adjust the styles as you like
style =
  # Define the maximum width of the widget.
  width: "50%"

  # Define the position, where to display the date.
  # Set properties you don't need to "auto"
  position:
    top:    "auto"
    bottom: "2%"
    left:   "1%"
    right:  "auto"

  # Misc
  text_align:     "left"
  text_transform: "none"
        
  # Font properties
  font:            "system-ui"
  font_color:      "#FFF"
  font_size:       "28px"
  font_weight:     "300"
  letter_spacing:  "0.025em"
  line_height:     "1.2em"
  text_shadow:     "0 0 0.2em black"
  #text-shadow:      "-1px 0 black, 0 1px black, 1px 0 black, 0 -1px black"
    
command: "osascript 'Time_Since_vienna.widget/Time_Since.applescript' \"#{options.theDate}\""

# Lower the frequency for more accuracy.
refreshFrequency: 1000 * 1 # (1000 * n) seconds

render: (o) -> """
   <div id="content">
     <span id="time"></span>
  </div>
"""

update: (output, dom) ->
  # Get our calculation results.
  values = output.slice(0,-1).split(" ")
  y = values[1] 
  m = values[3] 
  d = values[5] 
  h = values[7] 
  min = values[9] 
  s = values[11] 
    
  spcr = ' '
  a_d = 'and '
    
  if options.shorten == 'True'
        spcr = ''
        a_d = '& '
        y = 'y'
        m = 'm'
        d = 'd'
        h = 'h'
        min = 'm'
        s = 's'
        
  # If years = 0 then don't show year    
  if values[0] == '0'
        values[0] = ''
        y = ''
  else y = spcr + y + ' '
  
  # If months = 0 then don't show month        
  if values[2] == '0'
        values[2] = ''
        m = ''
  else m = spcr + m + ' '
            
  # If days = 0 then don't show day        
  if values[4] == '0'
        values[4] = ''
        d = ''
  else d = spcr + d + ' '
            
  # If hours = 0 then don't show hour        
  if values[6] == '0'
        values[6] = ''
        h = ''
  else h = spcr + h + ', '

  # If minute = 0 then don't show minute        
  if values[8] == '0'
        values[8] = ''
        min = ''
  else min = spcr + min + ' ' 
              
  # If seconds = 0 then don't show second        
  if values[10] == '0'
        values[10] = ''
        s = ''
        values[8] = a_d + values[8]
        h = spcr + h
  else 
        values[10] = a_d + values[10]   
        s = spcr + s + ' '
      
  # time_str = options.startPhrase + ' ' + values[0] + y + values[2]  + m + values[4] + d + values[6] + h + values[8] + min + values[10] + s + options.endPhrase ;
  time_str = options.startPhrase + ' ' + values[0] + y + values[2]  + m + values[4] + d # + values[6] + h + values[8] + min + values[10] + s + options.endPhrase ;
    
  $(dom).find("#time").html(time_str)
        
style: """
  top: #{style.position.top}
  bottom: #{style.position.bottom}
  right: #{style.position.right}
  left: #{style.position.left}
  width: #{style.width}
  padding: 1.0em 0
  height: 0em
  font-family: #{style.font}
  color: #{style.font_color}
  font-weight: #{style.font_weight}
  text-align: #{style.text_align}
  text-transform: #{style.text_transform}
  text-shadow: 0 0 0.2em black
  font-size: #{style.font_size}
  letter-spacing: #{style.letter_spacing}
  text-shadow: #{style.text_shadow}
  line-height: #{style.line_height}
"""
