<template>
  <div v-if="popUp && popUp.data.open">
    <bkt-pop-up-frame v-if="(popUp && popUp.data.open) && (popUp.data.type == 'normal' || popUp.data.type == 'delete')"
                      name="modal">
      <div v-if="popUp.data.title" class="flex-row-center-centered">
        <h1 class="fs-1_8rem font-weight-700 text-center" v-html="popUp.data.title"></h1>
      </div>
      <div v-if="popUp.data.subtitle" class="flex-row-center-centered mt-3 mb-5">
        <p class="fs-1_6rem font-weight-500 text-center" v-html="popUp.data.subtitle"></p>
      </div>

      <div v-if="popUp.data.textClose && popUp.data.textConfirm" class="flex-row-around-centered mt-5 fs-1_8rem">
        <button class="border-bkt-dark-grey width-15rem rounded-2px py-2" @click="close">{{ popUp.data.textClose }}
        </button>
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
          <bkt-spinner
              v-show="popUp.data.loading"
              :color="!popUp.data.type || popUp.data.type === 'normal' ? 'blue' : (popUp.data.type === 'delete' ? 'red' : '')">
            {{ popUp.data.textLoading }}
          </bkt-spinner>
          <span
              v-show="!popUp.data.loading"
          >{{ popUp.data.textConfirm }}</span>
        </button>
      </div>
    </bkt-pop-up-frame>
    <bkt-pop-up-frame v-else-if="popUp && popUp.data.open && popUp.data.type == 'action_done' " name="modal">
      <div class="flex-row-center-centered justify-content-center">
        <lottie-player src="https://assets2.lottiefiles.com/packages/lf20_newtztyc.json" background="transparent"
                       speed="1" style="width: 200px; height: 200px; margin-top: -3rem;" loop autoplay></lottie-player>
      </div>

      <div v-if="popUp.data.title" class="flex-row-center-centered">
        <h1 class="fs-1_8rem font-weight-700 text-center" v-html="popUp.data.title"></h1>
      </div>

      <div v-if="popUp.data.description" class="flex-row-center-centered">
        <h1 class="fs-1_2rem font-weight-500 text-center" v-html="popUp.data.description"></h1>
      </div>

      <div v-if="popUp.data.textConfirm" class="flex-row-center-centered mt-5 fs-1_8rem">
        <button
            class="min-w-15rem rounded-2px bkt-bg-blue bkt-white py-2 font-weight-600 fs-1_6rem"
            @click="confirm(false)"
        >
          <span>{{ popUp.data.textConfirm }}</span>
        </button>
      </div>
    </bkt-pop-up-frame>
    <bkt-pop-up-frame
        v-else-if="popUp && popUp.data.open && popUp.data.type === 'edit-entity-tags'"
        name="modal">
      <component
          :is="popUp.data.type"
          :entity-id="popUp.data.entityId"
          :fetch-tags-from-entity-path="popUp.data.fetchTagsFromEntityPath"
          :toggle-tag-from-entity-path="popUp.data.toggleTagFromEntityPath"
          :refresh-entity-list-path="popUp.data.refreshEntityListPath"
          @close="close"
      ></component>
    </bkt-pop-up-frame>
<!--    INFO: GENERIC MODAL-->
    <bkt-pop-up-frame
        v-else-if="popUp.data.type === 'custom'"
        :closable="popUp.data.closable"
        @close="close"
    >
      <component
          :is="popUp.data.componentName"
          v-bind="popUp.data"
          @close="close"
      ></component>
    </bkt-pop-up-frame>
  </div>
</template>

<script>
import store from "../store";
import BktSpinner from './BktSpinner'
import BktPopUpFrame from "./BktPopUpFrame";
import EditEntityTags from './EditEntityTags'
import InfoFilterCategoryTags from "./InfoFilterCategoryTagsComponents/InfoFilterCategoryTags";
import PopUpInfoInterviewStatus from './PopUpComponents/PopUpInfoInterviewStatus'
import PopUpSetAnotherInterview from './PopUpComponents/PopUpSetAnotherInterviewer'
import PopUpSetInterview from './PopUpComponents/PopUpSetInterview'

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
    confirm(loading = true) {
      store.commit('popUp/update', {loading: loading})
      this.popUp.data.confirm()
    }
  },
  components: {
    BktSpinner,
    BktPopUpFrame,
    EditEntityTags,
    InfoFilterCategoryTags,
    PopUpInfoInterviewStatus,
    PopUpSetInterview,
    PopUpSetAnotherInterview
  },
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
