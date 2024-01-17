import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { WeatherData } from '../../../variables.js';

const getWeatherIcon = (code) => {
  if (code === "01d" || code === "01n") {
    return "clear-sky";
  } else if (code === "02d" || code === "02n" || code === "03d" || code === "03n" || code === "04d" || code === "04n") {
    return "clouds";
  } else if (code === "09d" || code === "09n") {
    return "clouds-showers-scattered";
  } else if (code === "10d" || code === "10n") {
    return "clouds-showers";
  } else if (code === "11d" || code === "11n") {
    return "storms";
  } else if (code === "13d" || code === "13n") {
    return "snow";
  } else if (code === "50d" || code === "50n") {
    return "fog";
  } else {
    return "clear-night";
  }
}



export default () => Widget.Overlay({
  child: Widget.Box({
    class_name: 'launcher-weather',
    setup: self => {
      self.hook(WeatherData, (self) => {
        self.css = `background-image: url('${App.configDir}/assets/weather/weather-${getWeatherIcon(WeatherData.value["weather"][0]["icon"])}.jpg');min-width: 20px; min-height:180px;background-size: cover;background-position: center;`
      })
    },
  }),
  overlays: [
    Widget.Box({
      class_name: 'launcher-weather-g',
    }),
    Widget.Box({
      vertical: true,
      class_name: 'launcher-weather-info',
      children: [
        Widget.Label({
          class_name: 'launcher-weather-temp',
          setup: self => {
            self.hook(WeatherData, (self) => {
              self.label = `${Math.trunc(WeatherData.value["main"]["temp"])}°C`
            })
          },
          vpack: 'center',
          hpack: 'start',
          truncate: 'end',
        }),
        Widget.Label({
          class_name: 'launcher-weather-feelslike',
          setup: self => {
            self.hook(WeatherData, (self) => {
              self.label = `Feels like ${Math.trunc(WeatherData.value["main"]["feels_like"])}°C`
            })
          },
          vpack: 'center',
          hpack: 'start',
          truncate: 'end',
        }),
        Widget.Label({
          class_name: 'launcher-weather-city',
          setup: self => {
            self.hook(WeatherData, (self) => {
              self.label = `${WeatherData.value["name"]}`
            })
          },
          vpack: 'center',
          hpack: 'start',
          truncate: 'end',
        }),
      ],
    })
  ]
})
