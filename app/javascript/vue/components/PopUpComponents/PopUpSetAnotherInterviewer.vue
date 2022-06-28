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

      <bkt-auto-suggestion
          class="mb-1rem"
          :value="autoSelect"
          @selected="preSetInterview"
          :link="`${$routes.generate('company_managers')}/?access_level_int[]=manager&access_level_int[]=hr&access_level_int[]=account_owner&access_level_int[]=account_owner`"
      >
      </bkt-auto-suggestion>

      <bkt-button type="interview" class="mb-2" @click="setInterviewer">
        Apply
      </bkt-button>
    </div>
  </div>
</template>
<script>
import BktAutoSuggestion from "../BktAutoSuggestion";
import axios from "../../plugins/axios";
import BktButton from "../BktButton";
export default {
  props: ['campaignId', 'employeeId'],
  data() {
    return {
      autoSelect: null,
      autoSelectId: null
    }
  },
  methods: {
    preSetInterview(e){
      this.autoSelect = `${e.firstname} ${e.lastname}`
      this.autoSelectId = e.id
    },
    async setInterviewer() {
      if (this.autoSelectId === null) return

      try {
        await axios.patch(`/campaigns/interview_sets/${this.campaignId}.json`, {
          'employee_id': this.employeeId,
          'interviewer_id': this.autoSelectId
        })

        this.$emit('close')
      } catch (e) {
        console.log(e)
      }
    }
  },
  components: {BktButton, BktAutoSuggestion}
}
</script>