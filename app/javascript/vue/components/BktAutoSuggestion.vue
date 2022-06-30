<template>
  <div
      v-click-outside="hide"
      class="position-relative">
    <input
        class="d-block bkt-bg-light-grey3 border-bkt-light-grey pointer-event  bkt-white-onclick p-3 rounded-5px min-w-15rem width-100"
        ref="selectText"
        @focus="toggleDisplay"
        @input="preSearch"
        type="text" :value="text">
    <div
        v-if="display"
        class="position-absolute bkt-bg-white rounded-2px bkt-box-shadow-medium z-index-5 max-h-30rem overflow-y-auto"
        style="left: 0; right: 0; width: inherit"
    >
      <button
          v-for="(item, idx) in entities"
          :key="idx"
          class="flex-row-start-centered width-100 p-3 fs-1_6rem bkt-bg-light-grey9-hover"
          @click="manageSelected(item)"
      >
        <span class="d-inline-block text-truncate">
        {{ `${item.firstname} ${item.lastname}` }}
        </span>
      </button>
    </div>
  </div>
</template>

<script>
import axios from "../plugins/axios";

export default {
  props: {
    link: {
      type: String,
      default() {
        return '';
      }
    },
    value: {
      type: String,
      default() {
        return null
      }
    }
  },
  data() {
    return {
      entities: null,
      display: false,
      text: null
    }
  },
  created() {
    this.preSearch({value: ''})
  },
  computed: {
  },
  methods: {
    async preSearch(e) {
      this.entities = await this.search(e.value)
    },
    async search(text = '') {
      try {
        const res = await axios.get(this.link, {params: {text}})

        return res.data.users
      } catch (e) {
        console.log(e)
        return null
      }
    },
    hide() {
      this.$refs.selectText.classList.remove('border-bkt-dark-grey')
      this.$refs.selectText.classList.remove('select-arrow-active')

      this.display = false
    },
    toggleDisplay() {
      this.$refs.selectText.classList.add('border-bkt-dark-grey')
      this.$refs.selectText.classList.add('select-arrow-active')
      this.display = !this.display
    },
    manageSelected(item) {
      this.hide()
      this.text = `${item.firstname} ${item.lastname}`
      this.$emit('selected', item)
    }
  }
}
</script>

<style scoped>
p:after {
  position: absolute;
  content: "";
  top: 20px;
  right: 10px;
  width: 0;
  height: 0;
  border: 6px solid transparent;
  border-color: black transparent transparent transparent;
}
p.select-arrow-active:after {
  border-color: transparent transparent black transparent;
  top: 13px;
}

</style>
