import Vue from 'vue'
import Vuex from 'vuex'
import searchModule from "./search.module";

Vue.use(Vuex)

const store = new Vuex.Store({
  // strict: true,
  modules: {
    search: searchModule
  }
})

export default store