
export default {
  namespaced: true,
  state: {
    value: ''
  },
  mutations: {
    set(state, value) {
      state.value = value
    }
  }
}