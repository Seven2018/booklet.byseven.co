
<template>
  <div style="width: 50vh">
    <div class="flex-row-between-centered p-4">
      <h1 class="fs-1_8rem">Edit campaign tags</h1>
      <div @click="$emit('close')" class="cursor-pointer">
        <span  class="iconify" data-icon="akar-icons:cross" data-width="20" data-height="20"></span>
      </div>
    </div>

    <div>
      <div
          class="flex-row-start-centered p-4 bkt-bg-light-grey9"
          @click="focusInput"
      >
        <bkt-tag
            v-for="(tag, idx) in selectedTags"
            :key="idx"
            :cancelable="true"
        >
          {{tag}}
        </bkt-tag>
        <input ref="inputField" type="text" class="border-none bg-transparent" style="height: 20px;width: 3px;">
      </div>
      <div class="flex-column bkt-bg-red" style="height: 200px; overflow-y: auto">
        <p class="m-4 bkt-light-grey fs-1_2rem">Select a tag or create new one</p>
        <bkt-tag
            v-for="(tag, idx) in suggestionTags"
            :key="idx"
            :cancelable="false"
        >
          {{tag}}
        </bkt-tag>
      </div>
    </div>
  </div>
</template>

<script>
import BktTag from "./BktTag";
export default {
  components: {BktTag},
  props: ['campaignId'],
  data() {
    return {
      selectedTags: ['test', 'lol', 'mdr', 'safdjk'],
      suggestionTags: ['zxcv', 'poiu', 'qwer', 'lllllllllo']
    }
  },
  methods: {
    focusInput() {
      this.$refs.inputField.focus()
    }
  }
}
</script>