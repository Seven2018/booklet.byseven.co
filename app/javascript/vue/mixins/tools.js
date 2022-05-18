
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
    }
  }
}