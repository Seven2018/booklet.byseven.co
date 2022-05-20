
const routes = {
  objective_new: '/objective/elements/new',
  objective_list: '/objective/elements/list',
  objective_user_show: '/objective/users/{id}',
  objective_user_info: '/objective/users/{id}/info',
  objective_user_list_current: '/objective/users/{id}/list_current',
  objective_user_list_archived: '/objective/users/{id}/list_archived',
  objective_elements_archive: '/objective/elements/{id}/archive',
  objective_elements_unarchive: '/objective/elements/{id}/unarchive',
  objective_elements_id: '/objective/elements/{id}',
  objective_user_my_team_current_list: '/objective/users/{id}/my_team_objectives_current_list',
  objective_user_my_team_archived_list: '/objective/users/{id}/my_team_objectives_archived_list',
  objective_user_my_team_objectives: '/objective/users/{id}/my_team_objectives'
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
