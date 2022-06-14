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
    fetchPage(page) {
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'interview_forms_list',
        params: {
          'page[number]': page,
        }
      })
    },
  }
}