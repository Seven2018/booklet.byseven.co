
<template>
  <div class="bkt-box-shadow-medium p-4 rounded-5px">
    <user-info-in-table class="mt-4"
                        :user="{...(row.employee_interview || row.manager_interview).interview.employee}"></user-info-in-table>

    <p class="fs-1_2rem font-weight-500 flex-row-center-centered mt-4 mb-2">
      {{ generateInterviewsStatusSentence(...row) }}
    </p>

    <interview-status :set-interview="row"></interview-status>

    <div v-for="objInterview in [row.employee_interview, row.manager_interview, row.crossed_interview]">
      <div v-if="objInterview" class="flex-row-between-centered mt-5">
        <div class="flex-row-between-centered">
          <img class="rounded-circle width-3rem height-3rem"
               :src="objInterview.interview.employee.picture"
               onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
               alt="">
          <p class="font-weight-500 text-truncate fs-0_8rem">
            {{userLabel[objInterview.interview.label]}}
          </p>
        </div>
        <div class="flex-row-between-centered">
          <p
              class="p-2 fs-0_8rem"
              :class="[getColorByCampaignStatus(objInterview.interview.status), getBorderColorByInterviewStatus(objInterview.interview.status)]">
            {{objInterview.interview.status | cleanUnderscore | capitalize}}
          </p>

          <bkt-button
              v-if="objInterview.interview.label !== 'Employee'
              || objInterview.interview.label === 'Employee' && objInterview.interview.status === 'submitted'"
              :href="$routes.generate('interviews_id', {id: objInterview.interview.id})"
              :disable="objInterview.interview.label === 'Crossed' && objInterview.interview.status === 'not_available_yet'"
              class="ml-3 fs-0_8rem" type="interview"
          >
            <span class="iconify" data-icon="akar-icons:arrow-right" data-width="10" data-height="10"></span>
          </bkt-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import UserInfoInTable from "../../../components/UserInfoInTable";
import tools from "../../../mixins/tools";
import InterviewStatus from "../../../components/interviews/InterviewStatus";
import BktButton from "../../../components/BktButton";
export default {
  mixins: [tools],
  props: ['row'],
  data() {
    return {
      userLabel: {
        Employee: 'interviewee',
        Manager: 'interviewer',
        Crossed: 'Cross review'
      }
    }
  },
  components: {BktButton, InterviewStatus, UserInfoInTable},
}
</script>