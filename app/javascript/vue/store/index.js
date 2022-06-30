import Vue from 'vue'
import Vuex from 'vuex'
import searchModule from "./search.module";
import adminObjectivesModule from "./admin-objectives.module";
import objectiveUserModule from "./objective-user.module";
import popUpModule from "./pop-up.module";
import myTeamObjectivesModule from "./my-team-objectives.module";
import targetModule from "./target.module";
import targetTemplateModule from "./target-template.module";
import genericFetchEntityModule from "./generic-fetch-entity.module";
import tagsModule from "./tags.module";
import groupTagModule from "./group-tag.module";

Vue.use(Vuex)

const store = new Vuex.Store({
  // strict: true,
  modules: {
    search: searchModule,
    adminObjectives: adminObjectivesModule,
    objectiveUser: objectiveUserModule,
    popUp: popUpModule,
    myTeamObjectives: myTeamObjectivesModule,
    targetObjectives: targetModule,
    targetTemplateObjectives: targetTemplateModule,
    genericFetchEntity: genericFetchEntityModule,
    tagsModule: tagsModule,
    groupsTag: groupTagModule
  }
})

export default store