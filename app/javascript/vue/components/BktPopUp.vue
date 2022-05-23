<template>
  <transition v-if="popUp && popUp.data.open" name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container rounded-15px">
          <div v-if="popUp.data.title" class="flex-row-center-centered">
            <h1 class="fs-1_8rem font-weight-700 text-center" v-html="popUp.data.title"></h1>
          </div>

          <div v-if="popUp.data.textClose && popUp.data.textConfirm" class="flex-row-around-centered mt-5 fs-1_8rem">
            <button class="border-bkt-dark-grey width-15rem rounded-2px py-2" @click="close">{{popUp.data.textClose}}</button>
            <button
                class="min-w-15rem rounded-2px border-bkt-objective-blue py-2"
                :class="[!popUp.data.type
                  || popUp.data.type === 'normal' ?
                  'bkt-bg-objective-light-blue bkt-objective-blue border-bkt-objective-blue' : '',
                   popUp.data.type === 'delete' ?
                   'bkt-bg-light-red bkt-red border-bkt-red' : '',
                   popUp.data.loading ? 'bkt-bg-white' : '']"
                @click="confirm"
            >
<!--              TODO: change if, by style, display block-->
              <bkt-spinner
                  :color="!popUp.data.type || popUp.data.type === 'normal' ? 'blue' : (popUp.data.type === 'delete' ? 'red' : '')" >
                {{popUp.data.textLoading}}
              </bkt-spinner>
<!--              <bkt-spinner-->
<!--                  v-if="popUp.data.loading"-->
<!--                  :color="!popUp.data.type || popUp.data.type === 'normal' ? 'blue' : (popUp.data.type === 'delete' ? 'red' : '')" >-->
<!--                {{popUp.data.textLoading}}-->
<!--              </bkt-spinner>-->
<!--              <span v-else>{{popUp.data.textConfirm}}</span>-->
            </button>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import store from "../store";
import BktSpinner from './BktSpinner'

export default {
  data() {
    return {
      popUp: store.state.popUp
    }
  },
  methods: {
    close() {
      store.commit('popUp/update', {open: false})
      if (this.popUp.data.close) this.popUp.data.close()
    },
    confirm() {
      store.commit('popUp/update', {loading: true})
      this.popUp.data.confirm()
    }
  },
  components: {BktSpinner},
}
</script>

<style scoped>
.modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: table;
  transition: opacity 0.3s ease;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}

.modal-container {
  width: fit-content;
  margin: 0px auto;
  padding: 20px 30px;
  background-color: #fff;
  border-radius: 2px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.3s ease;
  font-family: Helvetica, Arial, sans-serif;
}

.modal-header h3 {
  margin-top: 0;
  color: #42b983;
}

.modal-body {
  margin: 20px 0;
}

.modal-default-button {
  float: right;
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter {
  opacity: 0;
}

.modal-leave-active {
  opacity: 0;
}

.modal-enter .modal-container,
.modal-leave-active .modal-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>