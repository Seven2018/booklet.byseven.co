import axios from "../plugins/axios";
import routes from "../constants/routes";

export default {
  namespaced: true,
  state: {
    targetList: null,
    pagination: null
  },
  mutations: {
    setTargetList(state, value) {
      state.targetList = value
    },
    setPagination(state, value) {
      state.pagination = value
    },
  },
  actions: {
    async fetchTargetList({commit}) {
      const res = await axios.get(routes.generate('objective_target_list'))

      commit('setTargetList', res.data['objective/elements'])
      commit('setPagination', res.data.meta)
    }
  }
}
