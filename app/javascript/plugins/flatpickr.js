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
  dateFormat: "d/m/Y",
})

flatpickr(".datepicker-defaulting-to-now", {
  disableMobile: true,
  dateFormat: "d/m/Y",
  defaultDate: Date.now()
})

flatpickr(".datepicker_", {
  disableMobile: true
})

flatpickr(".datepicker-inline", {
  disableMobile: true,
  dateFormat: "d/m/Y",
  inline: true
})

flatpickr(".datepicker-defaulting-to-end-of-month", {
  disableMobile: true,
  dateFormat: "d/m/Y",
  defaultDate: lastDayOfMonth()
})

flatpickr(".datepicker-defaulting-to-end-of-year", {
  disableMobile: true,
  dateFormat: "d/m/Y",
  defaultDate: lastDayOfYear()
})

flatpickr(".datepicker-range", {
  disableMobile: true,
  dateFormat: "d/m/Y",
  mode: 'range',
})

flatpickr(".timepicker", {
  enableTime: true,
  noCalendar: true,
  dateFormat: "H:i",
})

