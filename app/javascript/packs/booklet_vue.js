/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

// import Vue from 'vue'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     render: h => h(App)
//   }).$mount()
//   document.body.appendChild(app.$el)
//
//   console.log(app)
// })

// import { createApp } from 'vue'
// import App from '../app.vue'
//
// export const eventBus = createApp(App)
//
// createApp(App).mount('#app')


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


import Vue from 'vue/dist/vue.esm'
import 'es6-promise/auto'
import '../vue/plugins/directives'
import '../vue/plugins/pipes'
import '../vue/plugins/pop-up'
import routes from "../vue/constants/routes";
import App from '../vue/app.vue'
import ObjectiveUserIndex from '../vue/pages/objectives/users'
import ObjectiveElementIndex from '../vue/pages/objectives/elements'
import ObjectiveUserShow from '../vue/pages/objectives/users/show.vue'
import MyTeamObjectives from '../vue/pages/objectives/my_team_objectives'
import ObjectiveDatePicker from '../vue/components/ObjectiveDatePicker'
import ObjectiveTemplateIndex from '../vue/pages/objectives/templates'
import ObjectiveTemplateNew from '../vue/pages/objectives/templates/new'
import ObjectiveTemplateNewTargetView from '../vue/pages/objectives/templates/new_target_view'
import CustomToggleForErbForm from '../vue/components/CustomToggleForErbForm'
import CampaignIndex from '../vue/pages/interview_app/campaigns'
import InterviewTemplateIndex from '../vue/pages/interview_app/templates'
import InterviewReportIndex from '../vue/pages/interview_app/reports'

let app = null
let vuejsOpt = {
  el: '#app',
  components: {
    App,
    ObjectiveUserIndex,
    ObjectiveElementIndex,
    ObjectiveUserShow,
    MyTeamObjectives,
    ObjectiveDatePicker,
    ObjectiveTemplateIndex,
    ObjectiveTemplateNew,
    ObjectiveTemplateNewTargetView,
    CustomToggleForErbForm,
    CampaignIndex,
    InterviewTemplateIndex,
    InterviewReportIndex,
  }
}
Vue.prototype.$routes = routes

document.addEventListener('DOMContentLoaded', () => {

  app = new Vue(vuejsOpt)

// listening rebuildvuejs just in case we need to rebuild
  const event = document.createEvent('Event');
// Define that the event name is 'build'.
  event.initEvent('rebuildvuejs', true, true);
// Listen for the event.
  document.body.addEventListener('rebuildvuejs', (_) => {
    if (app) app.$destroy()

    app = new Vue(vuejsOpt)
  }, false);

})

//
//
//
// If the project is using turbolinks, install 'vue-turbolinks':
//
// yarn add vue-turbolinks
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: () => {
//       return {
//         message: "Can you say hello?"
//       }
//     },
//     components: { App }
//   })
// })
