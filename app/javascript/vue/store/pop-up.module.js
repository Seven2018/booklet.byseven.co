import Vue from 'vue/dist/vue.esm'

export default {
  namespaced: true,
  state: {
    data: {
      open: false
    }
  },
  mutations: {
    update(state, value) {
      if (value.confirm) {
        value.confirm = value.confirm.bind(Vue.prototype)
      }
      if (value.close) {
        value.close = value.close.bind(Vue.prototype)
      }

      state.data = {
        ...state.data,
        ...value
      }
    }
  }
}
