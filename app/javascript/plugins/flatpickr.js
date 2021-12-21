// app/javascript/plugins/flatpickr.js
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css" // Note this is important!

const lastDayOfMonth = () => {
  const today = new Date
  return new Date(today.getFullYear(), today.getMonth() + 1, 0)
}

flatpickr(".datepicker", {
  disableMobile: true,
  dateFormat: "d/m/Y",
})

flatpickr(".datepicker-defaulting-to-end-of-month", {
  disableMobile: true,
  dateFormat: "d/m/Y",
  defaultDate: lastDayOfMonth()
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

