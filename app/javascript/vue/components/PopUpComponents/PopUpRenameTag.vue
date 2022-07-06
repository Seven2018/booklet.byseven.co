
<template>
  <div>
    <input
        type="text"
        class="width-100 bkt-bg-light-grey9 fs-1_4rem font-weight-500 bkt-placeholder-dark-grey bkt-placeholder-fs-1_4rem border-0 p-3 rounded-5px my-3"
        v-model="tagName"
    >

    <bkt-button
        type="interview"
        @click="save"
    >Save</bkt-button>
  </div>
</template>
<script>
import BktButton from "../BktButton";
import axios from "../../plugins/axios";
export default {
  components: {BktButton},
  props: ['tag'],
  data() {
    return {
      tagName: this.tag.title
    }
  },
  methods: {
    async save() {
      console.log(this.tagName)
      try {
        await axios.put(
            this.$routes.generate('categories_id', {id: this.tag.id}),
            {title: this.tagName}
        )
        this.$emit('close')
      } catch (e) {
        console.log(e)
      }
    }
  }
}
</script>