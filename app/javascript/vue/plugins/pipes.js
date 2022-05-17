import Vue from 'vue/dist/vue.esm'

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
