import Vue from 'vue/dist/vue.esm'
import moment from 'moment';

Vue.filter('capitalize', function (value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
})

Vue.filter('convert_hr', function (value) {
  if (!value) return ''
  if (value == 'hr') {
    return 'admin'
  } else {
    return value
  }
})

// value should be a new Date class
Vue.filter('formatDate', (value, formatStr = "DD MMM, YYYY") => {
  return moment(value).format(formatStr)
})
