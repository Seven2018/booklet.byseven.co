<template>
  <div>
    <div class="flex-row-between-centered my-4 pb-4">
      <p>
      Set cross review date
      </p>
      <div @click="$emit('close')" class="cursor-pointer">
        <span class="iconify" data-icon="charm:cross" data-width="25" data-height="25"></span>
      </div>
    </div>

    <div class="flex-row-start-centered">
      <datepicker
        :inline="true"
        @selected="selectedDateCallback"
        v-model="selectedDate"
        timePicker
        ></datepicker>
    </div>

    <div class="flex-row-center-centered text-center my-4 d-block">
      <p> Date: {{ selectedDate | formatDate('DD MMM, YYYY') }} </p>
    </div>
    <div class="flex-row-center-centered text-center my-4 d-block">
      <p> Start Time: <input class="timepicker_24"  type='time' v-model='startSelectedDate'> </input> </p>
      <p> End Time: <input class="timepicker_24" type='time' v-model='endSelectedDate'> </input> </p>
    </div>
    <div class="flex-row-center-centered text-center my-4 d-block">
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
export default {
  props: ['campaignId', 'crossId', 'startDate', 'endDate'],
  data() {
    return {
      selectedDate: this.startDate,
      startSelectedDate: this.$options.filters.formatDate(this.startDate, 'HH:mm'),
      endSelectedDate: this.$options.filters.formatDate(this.endDate, 'HH:mm'),
    }
  },
  methods: {
    selectedDateCallback(date) {
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
  components: {Datepicker, BktButton}
}
</script>
