
<template>
  <div
      v-if="items.length >= 1"
      v-click-outside="hide"
      class="position-relative max-w-25rem width-100">
    <p
        ref="selectText"
        @click.stop="toggleDisplay"
        class="bkt-bg-light-grey3 border-bkt-light-grey pointer-event  bkt-white-onclick p-3 rounded-5px min-w-15rem  pr-5">
      {{toDisplay}}
    </p>
    <div
        v-if="display"
        class="position-absolute bkt-bg-white rounded-2px bkt-box-shadow-medium z-index-5 overflow-y-auto max-h-30rem"
        style="left: 0; right: 0; width: inherit"
    >
      <button
          v-for="(item, idx) in items"
          :key="idx"
          class="flex-row-start-centered width-100 p-3 fs-1_6rem bkt-bg-light-grey9-hover"
          @click="manageSelected(item)"
      >
        <span class="d-inline-block text-truncate">
          {{item.display}}
        </span>
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    items: {
      type: Array,
      default() {
        return [{display: 'Nothing', value: 'nothing'}]
      }
    },
    value: {
      type: String,
      default() {
        return null
      }
    },
    preventFetchOnMount: {
      type: Boolean,
      default() {
        return false
      }
    }
  },
  data() {
    return {
      display: false
    }
  },
  mounted() {
    if (!this.value && !this.preventFetchOnMount)
      this.$emit('input', this.items[0].value)
  },
  computed: {
    toDisplay() {
      if (!this.value) {
        return this.items[0].display
      } else {
        return this.items.filter(item => item.value === this.value)[0].display
      }
    }
  },
  methods: {
    toggleSelect() {
    },
    toggleDisplay() {
      this.$refs.selectText.classList.add('border-bkt-dark-grey')
      this.$refs.selectText.classList.add('select-arrow-active')
      this.display = !this.display
    },
    hide() {
      this.$refs.selectText.classList.remove('border-bkt-dark-grey')
      this.$refs.selectText.classList.remove('select-arrow-active')

      this.display = false
    },
    manageSelected(item) {
      this.hide()
      this.$emit('input', item.value)
    }
  },
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
