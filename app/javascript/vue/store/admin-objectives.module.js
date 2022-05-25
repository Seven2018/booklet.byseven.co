import HTTP from '../plugins/axios'
import routes from '../constants/routes'
import store from "./index";

export default {
  namespaced: true,
  state: {
    users: null,
    error: null
  },
  mutations: {
    setUsers(state, value) {
      state.users = value
    },
    setError(state, value) {
      state.error = value
    }
  },
  actions: {
    async fetch({commit}) {
      try {
        const res = await HTTP.get(
          routes.generate('objective_list'),
          {params: {search: store.state.search.value} }
          )

        commit('setUsers', res.data)
      } catch (e) {
        commit('setError', e.message)
      }
    }
  }
}

