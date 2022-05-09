import Vue from 'vue'
import Vuex from 'vuex'
import searchModule from "./search.module";
import adminObjectivesModule from "./admin-objectives.module";
import objectiveUserModule from "./objective-user.module";

Vue.use(Vuex)

const store = new Vuex.Store({
  // strict: true,
  modules: {
    search: searchModule,
    adminObjectives: adminObjectivesModule,
    objectiveUser: objectiveUserModule
  }
})

export default store