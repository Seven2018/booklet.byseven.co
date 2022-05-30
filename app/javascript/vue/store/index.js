import Vue from 'vue'
import Vuex from 'vuex'
import searchModule from "./search.module";
import adminObjectivesModule from "./admin-objectives.module";
import objectiveUserModule from "./objective-user.module";
import popUpModule from "./pop-up.module";
import myTeamObjectivesModule from "./my-team-objectives.module";
import targetModule from "./target.module";

Vue.use(Vuex)

const store = new Vuex.Store({
  // strict: true,
  modules: {
    search: searchModule,
    adminObjectives: adminObjectivesModule,
    objectiveUser: objectiveUserModule,
    popUp: popUpModule,
    myTeamObjectives: myTeamObjectivesModule,
    targetObjectives: targetModule
  }
})

export default store