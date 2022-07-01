
<template>
  <div v-if="manager_interview || employee_interview || crossed_interview">

    <div class="modal-body info-modal__body width-auto">
      <div class="d-flex flex-column justify-content-start align-items-center mb-3rem">
        <img class="rounded-circle width-3rem height-3rem"
             :src="employee_interview.interview.employee.picture"
             onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
             alt="">

        <p class="fs-2rem font-weight-500 bkt-dark-grey">{{ `${employee_interview.interview.employee.firstname} ${employee_interview.interview.employee.lastname}` }}</p>
      </div>
    </div>

    <div class="d-flex justify-content-between align-items-center width-100 gap-2rem">
      <div v-for="interview in [manager_interview, employee_interview, crossed_interview]">
        <div v-if="interview">
          <div class="d-flex flex-column justify-content-start align-items-center width-25rem
                            border-bkt-light-grey5 rounded-5px p-1rem">

            <div v-if="interview.interview.label === 'Employee'">
              <img class="rounded-circle width-3rem height-3rem"
                   :src="interview.interview.employee.picture"
                   onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                   alt="">

            </div>
            <div v-else-if="interview.interview.label === 'Manager'">
              <img class="rounded-circle width-3rem height-3rem"
                   :src="interview.interview.interviewer.picture"
                   onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                   alt="">
            </div>
            <div v-else>
              <div class="d-flex">
                <img class="rounded-circle width-3rem height-3rem"
                     :src="interview.interview.employee.picture"
                     onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                     alt="">
                <img class="rounded-circle width-3rem height-3rem"
                     :src="interview.interview.interviewer.picture"
                     onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                     alt="">
              </div>
            </div>

            <p class="fs-1_4rem font-weight-600 bkt-dark-grey my-1rem">{{ label[interview.interview.label] }}</p>
            <p :class="getColorByCampaignStatus(interview.interview.status)" class="fs-1_4rem font-weight-500 mb-1rem">
            {{ cleanUnderscoreAndCapitalize(interview.interview.status) }}
            </p>

            <div v-if="interview.interview.label === 'Employee' || interview.interview.status === 'submitted' || overview ">
              <bkt-button
                type="none"
                :class="interview.interview.status === 'submitted' ? '' : 'disabled'"
                class="bkt-btn-blue-border"
                :href="$routes.generate('interview_id', {id: interview.interview.id})"
                >
                 View answers
              </bkt-button>
            </div>

            <div v-else-if="interview.interview.label === 'Manager'">
              <bkt-button
                type="none"
                class="bkt-btn-blue-border"
                :href="$routes.generate('interview_id', {id: interview.interview.id})"
                >
                {{ interview.interview.status === 'not_started' ? 'Start interview' : 'Continue interview' }}
              </bkt-button>
            </div>

            <div v-else-if="interview.interview.label === 'Crossed'">
              <bkt-button
                type="none"
                class="bkt-btn-blue-border"
                :class="interview.interview.status === 'not_available_yet' ? 'disabled' : ''"
                :href="$routes.generate('interview_id', {id: interview.interview.id})"
                >
                {{ interview.interview.status === 'not_available_yet' ? 'disabled' : '' }}
                {{ interview.interview.status === 'in_progress' ? 'Continue' : 'Start' }}
              </bkt-button>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
  </div>
</template>

<script>
import tools from '../../mixins/tools'
import BktButton from "../../components/BktButton";

const DEFAULT_LABEL = {
  'Employee': 'Interviewee',
  'Manager': 'Interviewer',
  'Crossed': 'Cross review'
}

export default {
  mixins: [tools],
  props: ['overview','manager_interview', 'crossed_interview', 'employee_interview'],
  data () {
    return {
      label: Object.assign({}, DEFAULT_LABEL),
    }
  },
  components: { BktButton}
}
</script>
