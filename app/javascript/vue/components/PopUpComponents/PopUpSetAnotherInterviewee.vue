<template>
  <div class="w-80vw w-sm-20vw">
    <div class="flex-row-between-centered my-4 pb-4 border-bottom-bkt-dark-grey">
      <p>
        Select another participant
      </p>


      <div  @click="$emit('close')" class="cursor-pointer">
        <span class="iconify" data-icon="charm:cross" data-width="25" data-height="25"></span>
      </div>
    </div>

    <div>
      <p v-if="type === 'employee'" class="fs-1_6rem font-weight-600 bkt-dark-grey mb-1rem">Choose the employee you wish to add</p>
      <p v-else class="fs-1_6rem font-weight-600 bkt-dark-grey mb-1rem">Choose an interviewer from this campaign</p>

      <bkt-auto-suggestion
          v-if="type === 'employee'"
          placeholder="Select an employee"
          class="mb-1rem"
          v-model="autoSelect"
          @selected="preSetInterviewee"
          :link="`${$routes.generate('company_managers')}/?access_level_int[]=employee&access_level_int[]=manager&access_level_int[]=hr&access_level_int[]=account_owner&access_level_int[]=account_owner`"
      >
      </bkt-auto-suggestion>
      <bkt-auto-suggestion
          v-else
          placeholder="Select an interviewer"
          class="mb-1rem"
          v-model="interviewerSelect"
          @selected="preSetInterviewer"
          :link="`${$routes.generate('company_managers')}/?access_level_int[]=manager&access_level_int[]=hr&access_level_int[]=account_owner&access_level_int[]=account_owner`"
      >
      </bkt-auto-suggestion>

      <bkt-button v-if="type === 'employee'" type="interview" class="mb-2" @click="setInterviewee">
        Continue
      </bkt-button>
      <bkt-button v-else type="interview" class="mb-2" @click="setInterviewer">
        Add employee
      </bkt-button>
    </div>
  </div>
</template>
<script>
import BktAutoSuggestion from "../BktAutoSuggestion";
import axios from "../../plugins/axios";
import BktButton from "../BktButton";
export default {
  props: ['campaignId'],
  data() {
    return {
      autoSelect: null,
      autoSelectId: null,
      type: 'employee',
      interviewerSelect: null,
      interviewerSelectId: null
    }
  },
  methods: {
    preSetInterviewee(e){
      this.autoSelect = `${e.firstname} ${e.lastname}`
      this.autoSelectId = e.id
    },
    preSetInterviewer(e){
      this.interviewerSelect = `${e.firstname} ${e.lastname}`
      this.interviewerSelectId = e.id
    },
    async setInterviewee() {
      if (this.autoSelectId === null) return

      this.type = 'interviewer'
    },
    async setInterviewer() {
      if (this.interviewerSelectId === null) return
      try {
        await axios.post(`/campaigns/interview_sets.json`, {
          campaign_id: this.campaignId,
          user_id: this.autoSelectId,
          interviewer_id: this.interviewerSelectId
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
