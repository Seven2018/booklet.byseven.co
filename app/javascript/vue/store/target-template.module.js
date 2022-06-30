import axios from "../plugins/axios";
import routes from "../constants/routes";

export default {
  namespaced: true,
  state: {
    targetTemplateList: null,
    pagination: null,
    search: null
  },
  mutations: {
    setTargetTemplateList(state, value) {
      state.targetTemplateList = value
    },
    setPagination(state, value) {
      state.pagination = value
    },
    setSearch(state, value) {
      state.search = value
    }
  },
  actions: {
    async fetchTargetTemplateList({commit, state}, params = {}) {
      if (state.search) {
        params = { ...params, ...state.search}
      }

      const res = await axios.get(
        routes.generate('objective_templates_list'),
        {
          params
        }
      )

      commit('setTargetTemplateList', res.data['objective/templates'])
      commit('setPagination', res.data.meta)
    }
  }
}
