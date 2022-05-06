import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    search: ''
  },
  mutations: {
    setSearch(state, value) {
      state.search = value
    }
  }
})

export default store