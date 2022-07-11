<template>
  <div
      v-click-outside="hide"
      class="position-relative">
    <input
        class="d-block bkt-bg-light-grey3 border-bkt-light-grey pointer-event  bkt-white-onclick p-3 rounded-5px min-w-15rem width-100"
        ref="selectText"
        @focus="displaySugg"
        @input="preSearch"
        type="text"
        :value="value"
        :placeholder="placeholder"
    >
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
    },
    placeholder: {
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
      text: null,
      timer: null,
      loading: false
    }
  },
  created() {
    // this.preSearch({target: {value: ''}})

    if (this.entities === null) this.preSearch({target: {value: ''}})
  },
  // async beforeUpdate() {
  //   if (this.value === null) {
  //     this.preSearch({target: {value: ''}})
  //   }
  // },
  computed: {
    // inputValue() {
    //   console.log('in computed')
    //   // if (this.entities === null) {
    //   //   this.preSearch({target: {value: ''}})
    //   // }
    //   return this.value
    // }
  },
  methods: {
    preSearch(e) {
      this.$emit('input', e.target.value)
      if (this.loading) return
      
      this.search(e.target.value)
    },
    async search(text = '') {
      if (this.timer) clearTimeout(this.timer)

      this.timer = setTimeout(async () => {
        try {
          this.onLoading()
          const res = await axios.get(this.link, {params: {text}})

          this.entities = res.data.users
        } catch (e) {
          console.log(e)
          this.entities = null
        }
        this.unLoading()
      }, 200)
    },
    hide() {
      this.$refs.selectText.classList.remove('border-bkt-dark-grey')
      this.$refs.selectText.classList.remove('select-arrow-active')

      this.display = false
    },
    displaySugg() {
      if (this.entities === null) this.preSearch({target: {value: ''}})

      this.$refs.selectText.classList.add('border-bkt-dark-grey')
      this.$refs.selectText.classList.add('select-arrow-active')
      this.display = true
      // this.$refs.selectText.click()
    },
    manageSelected(item) {
      this.hide()
      // this.text = `${item.firstname} ${item.lastname}`
      this.$emit('selected', item)
    },
    onLoading() {
      document.querySelector('body').classList.add('wait')
      this.loading = true
    },
    unLoading() {
      document.querySelector('body').classList.remove('wait')
      this.loading = false
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
