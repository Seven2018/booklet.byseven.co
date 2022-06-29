
<template>
  <div class="mt-4 flex-row-between-centered">
    <div class="flex-row-start-centered ">
      <div class="width-30rem border-right-bkt-light-grey">
        <user-info-in-table :user="{...leftUser, subtitle: userKind}"></user-info-in-table>
      </div>
      <div class="ml-3">
        <p class="fs-1_2rem font-weight-500 flex-row-start-centered">
          {{ interviews.employee_interview.interview.status_sentence }}
          <span @click="openInfo" class="cursor-pointer">
                <span class="iconify bkt-light-grey ml-3" data-icon="akar-icons:question"></span>
              </span>
        </p>

        <interview-status :set-interview="interviews"></interview-status>
      </div>
    </div>

    <div class="flex-row-end-centered">
      <bkt-button
          iconify="akar-icons:arrow-right"
          :left="false"
          :type="interviews.crossed_interview && interviews.crossed_interview.interview.status === 'submitted' || interviews.employee_interview.interview.status === 'submitted' ? 'white' : 'interview'"
          :href="$routes.generate('interviews_id', {id: interviews.crossed_interview && interviews.crossed_interview.interview.status === 'submitted' ?
              interviews.crossed_interview.interview.id : (userKind === 'interviewer' ? interviews.employee_interview.interview.id : interviews.manager_interview.interview.id)})"
      >
        {{ userKind === 'interviewer' ?
          myInterviewCampaignButtonSentenceForEmployee(interviews) :
          myInterviewCampaignButtonSentenceForManager(interviews)
        }}
      </bkt-button>
      <bkt-button
          iconify="akar-icons:arrow-right"
          class="ml-3"
          :left="false"
          v-if="userKind !== 'interviewer' && interviews.crossed_interview && interviews.crossed_interview.interview.status !== 'not_available_yet'"
          :type="interviews.crossed_interview.interview.status === 'submitted' ? 'white' : 'interview'"
          :href="$routes.generate('interviews_id', {id: interviews.crossed_interview.interview.id })"
      >
        {{ myInterviewCampaignButtonSentenceForCrossed(interviews) }}
      </bkt-button>
    </div>
  </div>
</template>
<script>
import UserInfoInTable from "../UserInfoInTable";
import InterviewStatus from "./InterviewStatus";
import tools from "../../mixins/tools";
import BktButton from "../BktButton";

export default {
  mixins: [tools],
  props: ['interviews', 'userKind', 'leftUser'],
  methods: {
    openInfo() {
      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-info-interview-status',
        closable: true,
      })
    }
  },
  components: {InterviewStatus, UserInfoInTable, BktButton}
}
</script>