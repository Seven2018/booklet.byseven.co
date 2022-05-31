import HTTP from '../plugins/axios'
import routes from '../constants/routes'
import store from "./index";

export default {
  namespaced: true,
  state: {
    pagination: null,
    users: null,
    error: null,
    search: null
  },
  mutations: {
    setPagination(state, value) {
      state.pagination = value
    },
    setSearch(state, value) {
      state.search = value
    },
    setUsers(state, value) {
      state.users = value
    },
    setError(state, value) {
      state.error = value
    }
  },
  actions: {
    async fetch({commit, state}, params = {}) {
      if (state.search) {
        params = { ...params, ...state.search}
      }

      try {
        const res = await HTTP.get(
          routes.generate('objective_list'),
          {
            params
          }
        )

        commit('setUsers', res.data.users)
        commit('setPagination', res.data.meta)
      } catch (e) {
        commit('setError', e.message)
      }
    }
  }
}

