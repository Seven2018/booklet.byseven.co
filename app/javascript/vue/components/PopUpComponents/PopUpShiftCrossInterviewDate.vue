<template>
  <div>

    <div class="flex-row-between-centered"
      style="padding-bottom: 20px !important;">

      <p class="fs-1_6rem font-weight-600 bkt-dark-grey mr-2rem">
      Schedule a meeting
      </p>

      <div @click="$emit('close')" class="cursor-pointer">
        <span class="iconify" data-icon="charm:cross" data-width="25" data-height="25"></span>
      </div>
    </div>

    <div class="d-flex justify-content-center">

      <vue-flat-pickr v-model="selectedDate"
                  :config="configDate"
                  class="hidden"></vue-flat-pickr>

    </div>


    <div class="d-flex flex-column justify-content-center align-items-center my-2rem">

      <div class="d-flex justify-content-between align-items-center width-15rem mb-1rem">

        <label class="fs-1_6rem font-weight-500 bkt-dark-grey mb-0 mr-1rem">From</label>

        <vue-flat-pickr v-model="startSelectedDate"
                    :config="configTime"
                    class="timepicker-mini width-7rem text-center"></vue-flat-pickr>

      </div>

      <div class="d-flex justify-content-between align-items-center width-15rem">

        <label class="fs-1_6rem font-weight-500 bkt-dark-grey mb-0 mr-1rem">to</label>

        <vue-flat-pickr v-model="endSelectedDate"
                    :config="configTime"
                    class="timepicker-mini width-7rem text-center"></vue-flat-pickr>

      </div>


    </div>

    <div class="d-flex justify-content-center align-items-center mb-2rem">

      <label class="fs-1_6rem font-weight-500 bkt-dark-grey m-0">
        Send email notification
      </label>

      <label class='flex-row-center-centered rounded-3px my-1rem mx-2rem border-bkt-light-grey5-0_5px'
             style='height: 2.4rem; width: 2.4rem;'
             @click="sendEmail()">

        <input type="hidden"
               name="send_email"
               value=""
               ref="sendEmailInput">

        <svg class="hidden"
             xmlns="http://www.w3.org/2000/svg"
             aria-hidden="true"
             role="img"
             width="1.8rem"
             height="1.8rem"
             preserveAspectRatio="xMidYMid meet"
             viewBox="0 0 16 16"
             ref="sendEmailSvg">
             <path fill="#3177b7" d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093l3.473-4.425a.267.267 0 0 1 .02-.022z"/>
        </svg>

      </label>

    </div>

    <div class="flex-row-center-centered text-center">

      <bkt-button class="mb-2"
                  type='interview'
                  @click="updateDate"
                  ref="submitButton">
        Update cross review
      </bkt-button>

    </div>

  </div>

</template>

<script>
  import axios from "../../plugins/axios";
  import BktButton from "../BktButton";
  import VueFlatPickr from 'vue-flatpickr-component';

  export default {
    props: ['campaignId', 'crossId', 'startDate', 'endDate', 'date'],
    data() {
      var offset = new Date().getTimezoneOffset();

      var preStartDate = (this.startDate != null) ? new Date(this.startDate) : Date.now()
      preStartDate = preStartDate.setHours(preStartDate.getHours() - (offset / 60 / 2))
      var preEndDate = (this.endDate != null) ? new Date(this.endDate) : Date.now()
      preEndDate = preEndDate.setHours(preEndDate.getHours() - (offset / 60 / 2))
      const preDate = (this.date != null) ? new Date(this.date) : Date.now()

      return {
        showDatePicker: false,
        selectedDate: preDate,
        startSelectedDate: this.$options.filters.formatDate(preStartDate, 'HH:mm'),
        endSelectedDate: this.$options.filters.formatDate(preEndDate, 'HH:mm'),
        configDate: {
          disableMobile: true,
          dateFormat: "j M, Y",
          inline: true
        },
        configTime: {
          enableTime: true,
          noCalendar: true,
          dateFormat: "H:i",
          time_24hr: true,
          position: 'auto center',
        },
      }
    },
    methods: {
      sendEmail() {
        const input = this.$refs.sendEmailInput
        const svg = this.$refs.sendEmailSvg

        if (input.value == '') {
          input.value = 'true'
          svg.classList.remove('hidden')
        } else {
          input.value = ''
          svg.classList.add('hidden')
        }
      },
      editing() {
        this.showDatePicker = true
      },
      selectedDateCallback(newDate) {
        this.showDatePicker = false
      },
      async updateDate() {
        var offset = new Date().getTimezoneOffset();

        const endHour = (parseInt(this.endSelectedDate.split(':')[0], 10) + (offset / 60 / 2)).toString()
        const endMin = this.endSelectedDate.split(':')[1]
        const startHour = (parseInt(this.startSelectedDate.split(':')[0], 10) + (offset / 60 / 2)).toString()
        const startMin = this.startSelectedDate.split(':')[1]


        const minDuration = Math.abs(Number(endMin) - Number(startMin))
        const hourDuration = Math.abs(Number(endHour) - Number(startHour))


        const year = this.$options.filters.formatDate(this.selectedDate, 'YYYY')
        const month = this.$options.filters.formatDate(this.selectedDate, 'M')
        const day = this.$options.filters.formatDate(this.selectedDate, 'DD')

        const sendEmail = this.$refs.sendEmailInput.value
        try {
          await axios.patch(`/interviews/${this.crossId}.json`, {}, {params: { interview: {
            campaign_id: this.campaignId,
            year: year,
            month: month,
            day: day,
            hour: startHour,
            min: startMin,
            duration: hourDuration * 60 + minDuration
          }, send_email: sendEmail }})
          this.$emit('close')
        } catch (e) {
        }
      }
    },
    components: {BktButton, VueFlatPickr}
  }
</script>
