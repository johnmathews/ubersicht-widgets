refreshFrequency: true  # We'll handle updates manually

style: """
bottom: -1%
right: 10px
color: #fff

#clock
  font-weight: 300
  opacity: 0.9
  font-family: system-ui
  display: flex
  align-items: center
  gap: 15px
  right: -1%
  min-width: 330px
  position: relative

.hour-min
  font-size: 8em
  font-variant-numeric: tabular-nums
  font-feature-settings: "tnum"

.clock-inf
  display: grid
  font-size: 3.5em
  line-height: 1
"""

render: ->
  """
<div id="clock">
  <span class="hour-min">00:00:00</span>
</div>
  """

afterRender: ->
  updateClock = ->
    time = new Date()
    hour = if time.getHours()   < 10 then '0' + time.getHours()   else time.getHours()
    min  = if time.getMinutes() < 10 then '0' + time.getMinutes() else time.getMinutes()
    sec  = if time.getSeconds() < 10 then '0' + time.getSeconds() else time.getSeconds()

    clockElement = document.querySelector('.hour-min')
    if clockElement?
      # clockElement.innerText = "#{hour}:#{min}:#{sec}"
      clockElement.innerText = "#{hour}:#{min}"

  # Update immediately, then once per second
  updateClock()
  # setInterval(updateClock, 1000)
