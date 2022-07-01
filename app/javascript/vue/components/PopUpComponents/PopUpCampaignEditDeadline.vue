
<template>
  <div class="width-30rem">
    <div class="flex-row-between-centered border-bottom-bkt-dark-grey pb-3">
      <p>Edit deadline</p>

      <div  @click="$emit('close')" class="cursor-pointer">
        <span class="iconify" data-icon="charm:cross" data-width="25" data-height="25"></span>
      </div>
    </div>

    <div class="flex-column">
      <input v-model="date" type="date" class="p-3 width-100 bkt-bg-light-grey9 rounded-5px my-4">
    </div>

    <bkt-button type="interview" @click="request">
      save
    </bkt-button>
  </div>
</template>
<script>
import BktButton from "../BktButton";
import axios from "../../plugins/axios";
export default {
  props: ['campaignId'],
  data() {
    return {
      date: null
    }
  },
  methods: {
    async request() {
      await axios.put(this.$routes.generate('campaigns_id', {id: this.campaignId }), {
        deadline: this.date
      })
      this.$emit('close')
    }
  },
  components: {BktButton}
}
</script>