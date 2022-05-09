import HTTP from '../plugins/axios'

export default {
  namespaced: true,
  state: {
    objectives: null,
    error: null
  },
  mutations: {
    setObjectives(state, value) {
      state.objectives = value
    },
    setError(state, value) {
      state.error = value
    }
  },
  actions: {
    async fetch(ctx) {
      try {
        const res = await HTTP.get('objectives/elements/list')

        ctx.commit('setObjectives', res.data)
      } catch (e) {
        ctx.commit('setError', e.message)
      }
    }
  }
}

