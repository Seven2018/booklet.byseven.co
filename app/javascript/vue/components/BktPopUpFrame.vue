<template>
  <div class="modal-mask">
    <div class="modal-wrapper">
      <div class="modal-container rounded-15px w-100vw-mobile" :style="boxStyle" >
        <div class="flex-row-end-centered"
             :class="title ? 'flex-row-between-centered border-bottom-bkt-light-grey p-3 mb-3' : ''">
          <p v-if="title" class="font-weight-600 fs-1_8rem mr-5">{{ title }}</p>

          <div v-if="closable" @click="$emit('close')" class="cursor-pointer">
            <span class="iconify" data-icon="charm:cross" data-width="25" data-height="25"></span>
          </div>
        </div>
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
import store from "../store";
import BktSpinner from './BktSpinner'

export default {
  props: ['closable', 'title', 'boxStyle'],
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
    confirm(loading = true) {
      store.commit('popUp/update', {loading: loading})
      this.popUp.data.confirm()
    },
    byPassCallBackClose() {
      store.commit('popUp/update', {open: false})
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
