// src/plugins/vuetify.js

import Vue from 'vue'
import Vuetify from 'vuetify'
// import {
//   VCard,
//   VRating,
//   VToolbar,
// } from 'vuetify/lib'
// import { Ripple } from 'vuetify/lib/directives'
// import 'vuetify/dist/vuetify.min.css'

Vue.use(Vuetify, {
  // components: {
  //   VCard,
  //   VRating,
  //   VToolbar,
  // },
  // directives: {
  //   Ripple,
  // },
})

const opts = {}

export default new Vuetify(opts)