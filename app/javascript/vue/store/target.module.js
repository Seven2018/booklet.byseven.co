import axios from "../plugins/axios";
import routes from "../constants/routes";

export default {
  namespaced: true,
  state: {
    targetList: null,
    pagination: null,
    search: null
  },
  mutations: {
    setTargetList(state, value) {
      state.targetList = value
    },
    setPagination(state, value) {
      state.pagination = value
    },
    setSearch(state, value) {
      state.search = value
    }
  },
  actions: {
    async fetchTargetList({commit, state}, params = {}) {
      if (state.search) {
        params = { ...params, ...state.search}
      }

      const res = await axios.get(
        routes.generate('objective_target_list'),
        {
          params
        }
      )

      commit('setTargetList', res.data['objective/elements'])
      commit('setPagination', res.data.meta)
    }
  }
}
