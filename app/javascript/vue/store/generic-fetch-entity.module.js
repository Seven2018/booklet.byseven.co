import HTTP from '../plugins/axios'
import routes from '../constants/routes'
import store from "./index";
import axios from "../plugins/axios";

export default {
  namespaced: true,
  state: {
    pagination: null,
    data: null,
    error: null,
    search: null
  },
  mutations: {
    setPagination(state, value) {
      state.pagination = value
    },
    setSearch(state, value) {
      state.search = value
    },
    setData(state, value) {
      state.data = value
    },
    setError(state, value) {
      state.error = value
    }
  },
  actions: {
    async fetch({commit, state}, {pathKey, params} = {}) {
      if (state.search) {
        params = { ...params, ...state.search}
      }

      try {
        const res = await HTTP.get(
          routes.generate(pathKey),
          {
            params
          }
        )

        commit('setData', res.data)
        commit('setPagination', res.data.meta)
      } catch (e) {
        commit('setError', e.message)
      }
    },
    async delete({commit, state}, {pathKey, id, dataKind, addToPath = ''}) {
      try {
        await axios.delete(routes.generate(pathKey, {id: id}))

        commit('setData', {
          ...state.data,
          [dataKind]: state.data[dataKind].filter(item => item.id != id)
        })
      } catch (e) {
        commit('setError', e.message)
      }
    }
  }
}

