
const routes = {
  objective_new: '/objective/elements/new',
  objective_list: '/objective/elements/list',
  objective_user_show: '/objective/users/{id}'
}

export default {
  generate(path, options) {
    if (path in routes) {
      let pathValue = routes[path]

      for (const key in options) {
        pathValue = pathValue.replace(`{${key}}`, options[key])
      }
      return pathValue
    } else {
      console.log('===== logs =====')
      console.log(`route key: ${path}, does not exist`)
      return ''
    }
  }
}