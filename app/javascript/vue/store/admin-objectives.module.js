import HTTP from '../plugins/axios'

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
    async fetch(ctx) {
      try {
        const res = await HTTP.get('objective/elements/list')

        ctx.commit('setUsers', res.data)
      } catch (e) {
        ctx.commit('setError', e.message)
      }
    }
  }
}

