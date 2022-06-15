import HTTP from "../plugins/axios";
import routes from "../constants/routes";

export default {
  namespaced: true,
  state: {
    tags: null,
    // campaignTags: null,
    error: null
  },
  mutations: {
    setTags(state, value) {
      state.tags = value
    },
  },
  actions: {
    async fetch({commit}, {kind, title}) {
      try {
        const res = await HTTP.get(
          routes.generate('categories'),
          {
            params: {kind, title}
          }
        )

        commit('setTags', res.data.categories)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    // async fetchCampaignTags({commit, dispatch}) {}
  }
}