
export default {
  namespaced: true,
  state: {
    value: localStorage.getItem('objective_search') || ''
  },
  mutations: {
    set(state, value) {
      localStorage.setItem('objective_search', value)
      state.value = value
    }
  }
}