// app/javascript/plugins/flatpickr.js
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css" // Note this is important!

flatpickr(".datepicker", {
  disableMobile: true,
  dateFormat: "d/m/Y",
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

