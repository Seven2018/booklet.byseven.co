import Vue from 'vue/dist/vue.esm'
import BktPopUp from "../components/BktPopUp";
import store from "../store";


Vue.component('bkt-pop-up', BktPopUp)


document.addEventListener('DOMContentLoaded', () => {
  Vue.prototype.$modal = {
    open(opt) {
      store.commit('popUp/update', {open: true, ...opt})
    },
    close() {
      store.commit('popUp/update', {open: false, loading: false})
    },
  }

  const app = document.querySelector('#app')

  if (app)
    app.innerHTML = app.innerHTML + '<bkt-pop-up></bkt-pop-up>'
})
