
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
  objective_user_my_team_objectives: '/objective/users/{id}/my_team_objectives',
  objective_target_list: '/objective/elements/target_list',
  objective_templates_new: '/objective/templates/new',
  objective_templates: '/objective/templates',
  objective_templates_list: '/objective/templates/list',
  objective_templates_id: '/objective/templates/{id}',
  objective_templates_edit: '/objective/templates/{id}/edit',
  objective_templates_new_target_view: '/objective/templates/new_target_view',
  campaign_draft_edit: '/campaign_draft/settings/edit',
  campaigns_list: '/campaigns/list',
  send_notification_email: '/send_notification_email/{id}.json',
  campaigns_id: '/campaigns/{id}',
  categories: '/categories',
  categories_from_campaign: '/categories/from_campaign',
  categories_from_template: '/categories/from_template',
  campaigns_toggle_tag: '/campaigns/{id}/toggle_tag',
  interview_forms_list: '/interview_forms/list',
  interview_forms: '/interview_forms',
  interview_forms_id: '/interview_forms/{id}',
  interview_forms_id_edit: '/interview_forms/{id}/edit',
  interview_forms_id_duplicate: '/interview_forms/{id}/duplicate',
  interview_forms_toggle_tag: '/interview_forms/{id}/toggle_tag',
  interviews_reports_edit: '/interviews/reports/edit',
  interviews_reports: '/interviews/reports/list',
  categories_groups: '/categories/groups',
  new_group_categories: '/categories/new_group'
}

export default {
  generate(path, options, pagination = null) {
    if (path in routes) {
      let pathValue = routes[path]

      for (const key in options) {
        pathValue = pathValue.replace(`{${key}}`, options[key])
      }

      if (pagination) pathValue = `${pathValue}?page[number]=${pagination}&page[size]=10`

      return pathValue
    } else {
      console.log('===== logs =====')
      console.log(`route key: ${path}, does not exist`)
      return ''
    }
  }
}
