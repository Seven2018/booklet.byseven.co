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
    async fetch({commit}, text) {
      try {
        const res = await HTTP.get(
          routes.generate('objective_list'),
          {
            params: {
              search: text
            }
          }
        )

        commit('setUsers', res.data.users)
      } catch (e) {
        commit('setError', e.message)
      }
    }
  }
}

