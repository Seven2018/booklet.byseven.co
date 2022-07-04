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
    search: null,
    tags: null
  },
  mutations: {
    setPagination(state, value) {
      state.pagination = value
    },
    setSearch(state, value) {
      state.search = value
    },
    setTags(state, value) {
      state.tags = value
    },
    setData(state, value) {
      state.data = value
    },
    setError(state, value) {
      state.error = value
    }
  },
  actions: {
    async fetch({commit, state}, {pathKey, pathKeyArgs = null, params} = {}) {
      if (state.search) {
        params = { ...params, ...state.search, tags: state.tags}
      }
      if (state.tags) {
        params = {...params, tags: state.tags.map(tag => tag.id)}
      }

      try {
        const res = await HTTP.get(
          routes.generate(pathKey, pathKeyArgs),
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
    async delete({commit, state}, {pathKey, id, dataKind, addToPath = null}) {
      try {
        let path = routes.generate(pathKey, {id: id})
        if (addToPath) path += addToPath

        await axios.delete(path)

        commit('setData', {
          ...state.data,
          [dataKind]: state.data[dataKind].filter(item => item.id != id)
        })
      } catch (e) {
        commit('setError', e.message)
      }
    },
  }
}

