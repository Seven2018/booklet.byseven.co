<template>
  <div class="w-80vw w-sm-20vw">
    <div class="flex-row-between-centered my-4 pb-4 border-bottom-bkt-dark-grey">
      <p>
        Select another interviewer
      </p>


      <div  @click="$emit('close')" class="cursor-pointer">
        <span class="iconify" data-icon="charm:cross" data-width="25" data-height="25"></span>
      </div>
    </div>

    <div>
      <p class="fs-1_6rem font-weight-600 bkt-dark-grey mb-1rem">Select another interview</p>

      <bkt-auto-suggestion @selected="autoSelect = $event" :link="$routes.generate('company_managers')"></bkt-auto-suggestion>
    </div>
  </div>
</template>
<script>
import BktAutoSuggestion from "../BktAutoSuggestion";
export default {
  data() {
    return {
      autoSelect: null
    }
  },
  components: {BktAutoSuggestion}
}
</script>