<template>
  <div>
    <div class="flex-row-between-centered w-40vw"
      style="padding-bottom: 20px !important;">
      <p style="font-weight: bold;">
      Schedule a meeting for the cross review
      </p>
      <div  @click="$emit('close')" class="cursor-pointer">
        <span class="iconify" data-icon="charm:cross" data-width="25" data-height="25"></span>
      </div>
    </div>

    <div class="flex-row-center-centered"
         :style="showDatePicker ? 'padding-bottom: 300px !important;' : ''">
      <objective-input-decoration title="" @editing="editing">
        {{ selectedDate | formatDate('DD MMM, YYYY') }}
        <datepicker
          v-if="showDatePicker"
          :inline="true"
          @selected="selectedDateCallback"
          v-model="selectedDate"
          ></datepicker>
      </objective-input-decoration>
    </div>

    <div class="flex-row-center-centered text-center my-4 d-block">
      <p style="font-weight: bold;" > Start Time: <input class="timepicker_24"  type='time' v-model='startSelectedDate'> </input> </p>
      <p style="font-weight: bold;" > End Time: <input class="timepicker_24" type='time' v-model='endSelectedDate'> </input> </p>
    </div>
    <div class="flex-row-center-centered text-center">
      <bkt-button class="mb-2" type='interview' @click="updateDate">
        Update cross review
      </bkt-button>
    </div>
  </div>
  </div>
</template>
<script>
import axios from "../../plugins/axios";
import Datepicker from 'vuejs-datepicker';
import BktButton from "../BktButton";
import moment from 'moment';
import ObjectiveInputDecoration from "../ObjectiveInputDecoration";
export default {
  props: ['campaignId', 'crossId', 'startDate', 'endDate', 'date'],
  data() {
    const preStartDate = (this.startDate != null) ? new Date(this.startDate) : Date.now()
    const preEndDate = (this.endDate != null) ? new Date(this.endDate) : Date.now()
    const preDate = (this.date != null) ? new Date(this.date) : Date.now()
    return {
      showDatePicker: false,
      selectedDate: preDate,
      startSelectedDate: this.$options.filters.formatDate(preStartDate, 'HH:mm'),
      endSelectedDate: this.$options.filters.formatDate(preEndDate, 'HH:mm'),
    }
  },
  methods: {
    editing() {
      this.showDatePicker = true
    },
    selectedDateCallback(newDate) {
      this.showDatePicker = false
    },
    async updateDate() {
      const endHour = this.endSelectedDate.split(':')[0]
      const endMin = this.endSelectedDate.split(':')[1]
      const startHour = this.startSelectedDate.split(':')[0]
      const startMin = this.startSelectedDate.split(':')[1]

      const minDuration = Math.abs(Number(endMin) - Number(startMin))
      const hourDuration = Math.abs(Number(endHour) - Number(startHour))


      const year = this.$options.filters.formatDate(this.selectedDate, 'YYYY')
      const month = this.$options.filters.formatDate(this.selectedDate, 'M')
      const day = this.$options.filters.formatDate(this.selectedDate, 'DD')
      try {
        await axios.patch(`/interviews/${this.crossId}.json`, {}, {params: { interview: {
          campaign_id: this.campaignId,
          year: year,
          month: month,
          day: day,
          hour: startHour,
          min: startMin,
          duration: hourDuration * 60 + minDuration,
        }}})
        this.$emit('close')
      } catch (e) {
      }
    }
  },
  components: {Datepicker, BktButton, ObjectiveInputDecoration}
}
</script>
