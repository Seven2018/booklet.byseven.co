import Vue from 'vue/dist/vue.esm'
import moment from 'moment';

Vue.filter('capitalize', function (value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
})

Vue.filter('cleanUnderscore', function (value) {
  if (!value) return ''

  return value.replace(/_/g, ' ').trim()
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

Vue.filter('truncateN', (value, n = 65) => {
  if (!value) return ''
  if (value.length > n) {
    return value.slice(0, (n -1)) + '...'
  } else {
    return value
  }
})
