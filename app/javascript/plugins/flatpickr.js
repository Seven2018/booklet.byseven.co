// app/javascript/plugins/flatpickr.js
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css" // Note this is important!

const lastDayOfMonth = () => {
  const today = new Date
  return new Date(today.getFullYear(), today.getMonth() + 1, 0)
}

const lastDayOfYear = () => {
  const today = new Date
  return new Date(today.getFullYear(), 12, 0)
}

flatpickr(".datepicker", {
  disableMobile: true,
  dateFormat: "j M, Y",
})

flatpickr(".datepicker-defaulting-to-now", {
  disableMobile: true,
  dateFormat: "j M, Y",
  defaultDate: Date.now()
})

flatpickr(".datepicker_", {
  disableMobile: true,
  dateFormat: "j M, Y"
})

flatpickr(".datepicker-inline", {
  disableMobile: true,
  dateFormat: "j M, Y",
  inline: true
})

flatpickr(".datepicker-defaulting-to-end-of-month", {
  disableMobile: true,
  dateFormat: "j M, Y",
  defaultDate: lastDayOfMonth()
})

flatpickr(".datepicker-defaulting-to-end-of-year", {
  disableMobile: true,
  dateFormat: "j M, Y",
  defaultDate: lastDayOfYear()
})

flatpickr(".datepicker-range", {
  disableMobile: true,
  dateFormat: "j M, Y",
  mode: 'range',
})

flatpickr(".timepicker", {
  enableTime: true,
  noCalendar: true,
  dateFormat: "H:i",
})

const timepicker24s = document.querySelectorAll('.timepicker_24')
timepicker24s.forEach((element) => {
  flatpickr(element, {
    enableTime: true,
    noCalendar: true,
    dateFormat: "H:i",
    time_24hr: true,
    defaultDate: element.dataset.defaultTime
  })
})
