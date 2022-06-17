import HTTP from "../plugins/axios";
import routes from "../constants/routes";

export default {
  namespaced: true,
  state: {
    groups: null,
    error: null
  },
  mutations: {
    setGroups(state, value) {
      state.groups = value
    },
  },
  actions: {
    async fetch({commit}, {kind}) {
      try {
        const res = await HTTP.get(
          routes.generate('categories_groups'),
          {
            params: {kind}
          }
        )

        commit('setGroups', res.data['group_categories'])
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async newGroup({commit, dispatch}, {name, kind}) {
      try {
        await HTTP.post(
          routes.generate('new_group_categories'),
          {name, kind}
        )
        dispatch('fetch', {kind})
      } catch (e) {
        commit('setError', e.message)
      }
    },
  }
}
