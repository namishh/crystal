import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

export const Uptime = Variable("0h 0m", {
  poll: [1000 * 60, ['bash', '-c', "uptime -p | sed -e 's/up //;s/ hours,/h/;s/ hour,/h/;s/ minutes/m/;s/ minute/m/'"], out => out.trim()],
})

export const Brightness = Variable(false, {
  poll: [1000, ['brightnessctl', 'g'], out => Number(out)],
})

const defaultvalue = {
  "weather": [
    {
      "id": 701,
      "main": "Weather Not Availalbe",
      "description": "Connect To Internet",
      "icon": "50d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 0,
    "feels_like": "Temp Not Available",
    "temp_min": 0,
    "temp_max": 0,
    "pressure": 0,
    "humidity": 0
  },
  "visibility": 1000,
  "wind": {
    "speed": 0,
    "deg": 0
  },
  "clouds": {
    "all": 20
  },
  "name": "New Delhi",
}

export const WeatherData = Variable(defaultvalue, {
  poll: [1000 * 60 * 60, ['bash', '-c', `${App.configDir}/scripts/weather.sh full`], out => JSON.parse(out)],
})

