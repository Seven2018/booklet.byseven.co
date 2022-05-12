import axios from "../plugins/axios";
import routes from "../constants/routes";

export default {
  namespaced: true,
  state: {
    employeesCurrent: null,
    employeesArchived: null,
    error: null
  },
  mutations: {
    setEmployeesCurrent(state, value) {
      state.employeesCurrent = value
    },
    setEmployeesArchived(state, value) {
      state.employeesArchived = value
    },
    setError(state, value) {
      state.error = value
    }
  },
  actions: {
    async fetchEmployeesCurrent({commit}) {
      try {
        const res = await axios.get(routes.generate('objective_my_team_current_list'))

        commit('setEmployeesCurrent', res.data)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async fetchEmployeesArchived({commit}) {
      try {
        const res = await axios.get(routes.generate('objective_my_team_archived_list'))

        commit('setEmployeesArchived', res.data)
      } catch (e) {
        commit('setError', e.message)
      }
    }
  }
}
