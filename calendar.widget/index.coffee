# CLOCK
showTime = ->
  time = new Date
  hour = time.getHours()
  min = time.getMinutes()
  sec = ""
  am_pm = 'AM'
  hour = if hour < 10 then '0' + hour else hour
  min = if min < 10 then '0' + min else min
  currentTime = '<span class="hour-min">' + hour + ':' + min + '</span>'
  document.getElementById('clock').innerHTML = currentTime
  return

setInterval showTime, 1000
  



# CALENDAR

sundayFirstCalendar = 'cal -h && date "+%-m %-d %y"'

mondayFirstCalendar =  'cal -h | awk \'{ print " "$0; getline; print "Mo Tu We Th Fr Sa Su"; \
getline; if (substr($0,1,2) == " 1") print "                    1 "; \
do { prevline=$0; if (getline == 0) exit; print " " \
substr(prevline,4,17) " " substr($0,1,2) " "; } while (1) }\' && date "+%-m %-d %y"'

command: sundayFirstCalendar

#Set this to true to enable previous and next month dates, or false to disable
otherMonths: true

refreshFrequency: 3600000

style: """
  top: 10px
  right: 10px
  color: #fff
  padding: 5px 5px 15px 15px
  background: rgba(#000, 0.2)
  border-radius: 13px
  
  table
    border-collapse: collapse
    table-layout: fixed
    margin-left: auto
    opacity: 0.9

  td
    text-align: center
    padding: 10px 10px
    font-family: system-ui

  thead tr
    &:first-child td
      font-size: 3em
      font-weight: 300

    &:last-child td
      font-size: 1rem
      padding-bottom: 10px 
      font-weight: 500 

  tbody td
    font-weight: 300 
    font-size: 1.2em

  .today
    font-weight: bold
    font-size: 1.4em
    color: white
    background: rgba(teal, 1)
    border-radius: 14px
    padding: 0px 0px 0px 0px

  .grey
    color: #ccc
    opacity: 0.9
"""

render: -> """
  <table>
    <thead>
    </thead>
    <tbody>
    </tbody>
  </table>
"""


updateHeader: (rows, table) ->
  thead = table.find("thead")
  thead.empty()

  thead.append "<tr><td colspan='7'>#{rows[0]}</td></tr>"
  tableRow = $("<tr></tr>").appendTo(thead)
  daysOfWeek = rows[1].split(/\s+/)

  for dayOfWeek in daysOfWeek
    tableRow.append "<td>#{dayOfWeek}</td>"

updateBody: (rows, table) ->
  #Set to 1 to enable previous and next month dates, 0 to disable
  PrevAndNext = 1

  tbody = table.find("tbody")
  tbody.empty()

  rows.splice 0, 2
  rows.pop()

  today = rows.pop().split(/\s+/)
  month = today[0]
  date = today[1]
  year = today[2]

  lengths = [31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30]
  if year%4 == 0
    lengths[2] = 29

  for week, i in rows
    days = week.split(/\s+/).filter((day) -> day.length > 0)
    tableRow = $("<tr></tr>").appendTo(tbody)

    if i == 0 and days.length < 7
      for j in [days.length...7]
        if @otherMonths == true
          k = 6 - j
          cell = $("<td>#{lengths[month-1]-k}</td>").appendTo(tableRow)
          cell.addClass("grey")
        else
          cell = $("<td></td>").appendTo(tableRow)

    for day in days
      day = day.replace(/\D/g, '')
      cell = $("<td>#{day}</td>").appendTo(tableRow)
      cell.addClass("today") if day == date

    if i != 0 and 0 < days.length < 7 and @otherMonths == true
      for j in [1..7-days.length]
        cell = $("<td>#{j}</td>").appendTo(tableRow)
        cell.addClass("grey")

update: (output, domEl) ->
  rows = output.split("\n")
  table = $(domEl).find("table")

  @updateHeader rows, table
  @updateBody rows, table
