import Vue from 'vue/dist/vue.esm'
import BktPopUp from "../components/BktPopUp";
import store from "../store";


// make use of store and, jquery
Vue.component('bkt-pop-up', BktPopUp)


document.addEventListener('DOMContentLoaded', () => {
  Vue.prototype.$modal = {
    open(opt) {
      store.commit('popUp/update', {open: true, ...opt})
    },
    close() {
      store.commit('popUp/update', {open: false})
    },
  }

  const app = document.querySelector('#app')

  if (app)
    app.innerHTML = app.innerHTML + '<bkt-pop-up></bkt-pop-up>'
})
