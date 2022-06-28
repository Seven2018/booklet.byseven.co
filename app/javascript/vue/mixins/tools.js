import routes from "../constants/routes";
import store from "../store";

export default {
  methods: {
    setHover(className) {
      const elems = document.querySelectorAll(`.${className}`)
      elems.forEach(el => {
        el.classList.add('bkt-bg-light-grey10')
      })
    },
    removeHover(className) {
      const elems = document.querySelectorAll(`.${className}`)
      elems.forEach(el => {
        el.classList.remove('bkt-bg-light-grey10')
      })
    },
    getIndicatorIconifyName(type) {
      if (type === 'boolean') {
        return 'ic:outline-toggle-on'
      } else if (type === 'numeric_value') {
        return 'ic:baseline-numbers'
      } else if (type === 'percentage') {
        return 'fa6-solid:percent'
      } else if (type === 'multi_choice') {
        return 'fluent:text-bullet-list-ltr-16-filled'
      }
    },
    filterMultiChoiceCount(opts) {
      let count = 0
      const regex = new RegExp(/^choice_.*/)

      for (const opt in opts) {
        if (regex.test(opt)) count++
      }
      return count
    },
    campaign_icon(type) {
      const icon = {
        crossed: 'uil:exchange',
        simple: 'uil:exchange',
        one_to_one: 'uil:exchange',
        feedback_360: 'mdi:star-shooting'
      }
      return icon[type]
    },
    campaign_type_str(type) {
      const types = {
        crossed: '1 to 1',
        simple: '1 to 1',
        one_to_one: '1 to 1',
        feedback_360: 'Feedback 360'
      }
      return types[type]
    },
    goto(key, id = null) {
      window.location.href = routes.generate(key, {id})
    },
    fetchPage(page, pathKey, pathKeyArgs = null) {
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: pathKey,
        pathKeyArgs,
        params: {
          'page[number]': page,
        }
      })
    },
    myInterviewCampaignButtonSentenceForEmployee(campaign) {
      if (campaign.employee_interview.interview.status === 'not_started')
        return 'Start my interview'
      else if (campaign.employee_interview.interview.status === 'in_progress')
        return 'Continue my interview'
      else if (campaign.crossed_interview && campaign.crossed_interview.interview.status === 'submitted')
        return 'View cross review answers'
      else if (campaign.employee_interview.interview.status === 'submitted')
        return 'View my answers'
    },
    myInterviewCampaignButtonSentenceForManager(campaign) {
      if (campaign.manager_interview.interview.status === 'not_started')
        return 'Start my interview'
      else if (campaign.manager_interview.interview.status === 'in_progress')
        return 'Continue my interview'
      else if (campaign.crossed_interview.interview && campaign.crossed_interview.interview.status === 'submitted')
        return 'View cross review answers'
      else if (campaign.manager_interview.interview.status === 'submitted')
        return 'View my answers'
    },
    myInterviewCampaignButtonSentenceForCrossed(campaign) {
      if (campaign.crossed_interview.interview.status === 'not_started')
        return 'Start my cross interview'
      else if (campaign.crossed_interview.interview.status === 'in_progress')
        return 'Continue my cross interview'
      else if (campaign.crossed_interview.interview.status === 'submitted')
        return 'View my cross answers'
    },
    isMobile() {
      return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    },
    getBgByCampaignStatus(status) {
      if (status === 'not_started') return 'bkt-bg-red'
      else if (status === 'in_progress') return 'bkt-bg-yellow'
      else if (status === 'submitted') return 'bkt-bg-green'
      else if (status === 'not_available_yet') return 'bkt-bg-light-grey'
    },

    getColorByCampaignStatus(status) {
      if (status === 'not_started') return 'bkt-red'
      else if (status === 'in_progress') return 'bkt-yellow'
      else if (status === 'submitted') return 'bkt-green'
      else if (status === 'not_available_yet') return 'bkt-light-grey'
    }
  }
}