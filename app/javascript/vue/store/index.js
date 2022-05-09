import Vue from 'vue'
import Vuex from 'vuex'
import searchModule from "./search.module";
import adminObjectivesModule from "./admin-objectives.module";

Vue.use(Vuex)

const store = new Vuex.Store({
  // strict: true,
  modules: {
    search: searchModule,
    adminObjectives: adminObjectivesModule
  }
})

export default store