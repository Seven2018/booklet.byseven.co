import axios from "../plugins/axios";
import routes from "../constants/routes";

export default {
  namespaced: true,
  state: {
    user: null,
    userId: null,
    employeesCurrent: null,
    employeesArchived: null,
    error: null
  },
  mutations: {
    setUser(state, value) {
      state.user = value
    },
    setUserId(state, userId) {
      state.userId = userId
    },
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
    async fetchUser({commit, state}) {
      try {
        const res = await axios.get(routes.generate('objective_user_info', {id: state.userId}))

        commit('setUser', res.data.user)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async fetchEmployeesCurrent({commit, state}) {
      try {
        const res = await axios.get(routes.generate('objective_user_my_team_current_list', {id: state.userId}))

        commit('setEmployeesCurrent', res.data.users)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async fetchEmployeesArchived({commit, state}) {
      try {
        const res = await axios.get(routes.generate('objective_user_my_team_archived_list', {id: state.userId}))

        commit('setEmployeesArchived', res.data.users)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async archiveObjectiveUser({commit, dispatch}, objectiveId) {
      try {
        await axios.post(routes.generate('objective_elements_archive', {id: objectiveId}))

        dispatch('fetchEmployeesCurrent')
        dispatch('fetchEmployeesArchived')
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async unarchiveObjectiveUser({commit, dispatch}, objectiveId) {
      try {
        await axios.post(routes.generate('objective_elements_unarchive', {id: objectiveId}))

        dispatch('fetchEmployeesCurrent')
        dispatch('fetchEmployeesArchived')
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async deleteObjectiveUser({commit, dispatch}, objectiveId) {
      try {
        await axios.delete(routes.generate('objective_elements_id', {id: objectiveId}))

        dispatch('fetchEmployeesCurrent')
        dispatch('fetchEmployeesArchived')
      } catch (e) {
        commit('setError', e.message)
      }
    }
  }
}
