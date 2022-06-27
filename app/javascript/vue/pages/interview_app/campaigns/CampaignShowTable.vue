
<template>
  <index-table
      :headers="headers"
      :table-data="set_interviews"
      :pagination="null"
      @fetch-page=""
      @row-click=""
      class="cursor-pointer"
  >
    <template v-slot="{manager_interview, employee_interview, crossed_interview}">
      <td>
        <user-info-in-table :user="employee_interview.interview.employee"></user-info-in-table>
      </td>

      <td>
        <p class="fs-1_6rem font-weight-500 bkt-light-grey6">
          {{employee_interview.interview.interview_form.title}}
        </p>
      </td>

      <td>
        <user-info-in-table :user="employee_interview.interview.interviewer"></user-info-in-table>
      </td>

      <td>
        <display-tag-in-index :tags="employee_interview.interview.interview_form.categories"></display-tag-in-index>
      </td>

      <td>
        <interview-status :set-interview="{manager_interview, employee_interview, crossed_interview}"></interview-status>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <bkt-dots-button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="goto('users_id', employee_interview.interview.employee.id)"
            >
              see interviewee profile
            </button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="openSetAnotherInterviewer"
            >
              set another interviewer
            </button>
          </bkt-dots-button>
        </div>
      </td>
    </template>
  </index-table>
</template>

<script>
import IndexTable from "../../../components/IndexTable";
import BktDotsButton from "../../../components/BktDotsButton";
import UserInfoInTable from "../../../components/UserInfoInTable";
import DisplayTagInIndex from "../../../components/DisplayTagInIndex";
import InterviewStatus from "../../../components/interviews/InterviewStatus";
import tools from "../../../mixins/tools";

export default {
  mixins: [tools],
  components: {InterviewStatus, DisplayTagInIndex, UserInfoInTable, IndexTable, BktDotsButton},
  props: ['set_interviews'],
  data() {
    return {
      headers: ['Interviewee', 'Template', 'Interviewer', 'Tags', 'Completion', ''],
    }
  },
  methods: {
    openSetAnotherInterviewer() {
      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-set-another-interview',
        closable: false,
      })
    }
  }
}
</script>