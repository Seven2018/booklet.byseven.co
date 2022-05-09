import axios from "../plugins/axios";
import routes from "../constants/routes";


export default {
  namespaced: true,
  state: {
    user: null,
    objectivesCurrent: null,
    objectivesArchived: null,
    error: null
  },
  mutations: {
    setUser(state, value) {
      state.user = value
    },
    setObjectivesCurrent(state, value) {
      state.objectivesCurrent = value
    },
    setObjectivesArchived(state, value) {
      state.objectivesArchived = value
    },
    setError(state, value) {
      state.error = value
    }
  },
  actions: {
    async fetchUser({commit}, userId) {
      try {
        const res = await axios.get(routes.generate('objective_user_info', {id: userId}))

        commit('setUser', res.data)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async fetchUserObjectivesCurrent({commit}, userId) {
      try {
        const res = await axios.get(routes.generate('objective_user_list_current', {id: userId}))

        commit('setObjectivesCurrent', res.data)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async fetchUserObjectivesArchived({commit}, userId) {
      try {
        const res = await axios.get(routes.generate('objective_user_list_archived', {id: userId}))

        commit('setObjectivesArchived', res.data)
      } catch (e) {
        commit('setError', e.message)
      }
    }
  }
}