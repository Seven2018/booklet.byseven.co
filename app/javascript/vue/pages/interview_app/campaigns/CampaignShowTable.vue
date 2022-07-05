
<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      :table-data="genericFetchEntity.data['set_interviews']"
      :pagination="genericFetchEntity.data['meta']"
      @fetch-page="fetchPage($event, 'campaigns_id_data_show', {id: campaign.id})"
      @row-click="rowClick"
      class="cursor-pointer"
  >
    <template v-slot="{manager_interview, employee_interview, crossed_interview}">
      <td>
        <user-info-in-table :user="(employee_interview || manager_interview).interview.employee"></user-info-in-table>
      </td>

      <td>
        <p class="fs-1_6rem font-weight-500 bkt-light-grey6">
          {{(employee_interview || manager_interview).interview.interview_form.title}}
        </p>
      </td>

      <td>
        <user-info-in-table :user="(employee_interview || manager_interview).interview.interviewer"></user-info-in-table>
      </td>

      <td>
        <display-tag-in-index :tags="(employee_interview || manager_interview).interview.interview_form.categories"></display-tag-in-index>
      </td>

      <td>
        <interview-status :set-interview="{manager_interview, employee_interview, crossed_interview}"></interview-status>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <bkt-dots-button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="goto('users_id', (employee_interview || manager_interview).interview.employee.id)"
            >
              see interviewee profile
            </button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="openSetAnotherInterviewer((employee_interview || manager_interview).interview.employee.id)"
            >
              set another interviewer
            </button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="sendNotif('invite', (employee_interview || manager_interview).interview.employee.id)"
            >
              Send invitation email
            </button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="sendNotif('remind', (employee_interview || manager_interview).interview.employee.id)"
            >
              Send reminder email
            </button>
            <button
                v-if="crossed_interview"
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="shiftCrossInterviewDate(crossed_interview.interview)"
            >
              Set cross review date
            </button>
          </bkt-dots-button>
        </div>
      </td>
    </template>
    <template v-slot:mobile-row="row">
      <campaign-show-mobile-row :row="row"></campaign-show-mobile-row>
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
import store from "../../../store";
import axios from "../../../plugins/axios";
import CampaignShowMobileRow from "./CampaignShowMobileRow";

export default {
  mixins: [tools],
  components: {CampaignShowMobileRow, InterviewStatus, DisplayTagInIndex, UserInfoInTable, IndexTable, BktDotsButton},
  props: ['overview','campaign'],
  data() {
    return {
      headers: ['Interviewee', 'Template', 'Interviewer', 'Tags', 'Completion', ''],
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  methods: {
    openSetAnotherInterviewer(employeeId) {
      // TODO: refactor next line
      const campaignId = this.campaign.id

      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-set-another-interviewer',
        closable: false,
        campaignId: campaignId,
        employeeId: employeeId,
        close() {
          store.dispatch('genericFetchEntity/fetch', {
            pathKey: 'campaigns_id_data_show',
            pathKeyArgs: {id: campaignId}
          })
        }
      })
    },
    sendNotif(emailType, employeeId) {
      axios.get(`/send_notification_email/${this.campaign.id}?email_type=${emailType}&user_id=${employeeId}&format=json`)

      if (emailType === 'invite') {
        this.$modal.open({
          type: 'action_done',
          title: `invitation is on its way !`,
          description: 'The employee will receive an email in a few moments.',
          textConfirm: 'Great !',
          confirm() {
            this.$modal.close()
          }
        })
      } else {
        this.$modal.open({
          type: 'action_done',
          title: `Reminder is on its way !`,
          description: 'The employee will receive an email in a few moments.',
          textConfirm: 'Great !',
          confirm() {
            this.$modal.close()
          }
        })
      }
    },
    shiftCrossInterviewDate(cross) {
      const campaignId = this.campaign.id
      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-shift-cross-interview-date',
        closable: false,
        campaignId: campaignId,
        crossId: cross.id,
        startDate: cross.starts_at,
        endDate: cross.ends_at,
        close() {
          store.dispatch('genericFetchEntity/fetch', {
            pathKey: 'campaigns_id_data_show',
            pathKeyArgs: {id: campaignId}
          })
        }
      })
    },
    rowClick(row) {
      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-set-interview',
        closable: true,
        overview: this.$props.overview,
        manager_interview: row['manager_interview'],
        crossed_interview: row['crossed_interview'],
        employee_interview: row['employee_interview'],
      })
    }
  }
}
</script>
