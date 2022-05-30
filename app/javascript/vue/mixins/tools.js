
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
    }
  }
}