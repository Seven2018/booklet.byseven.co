
<template>
  <objective-input-decoration title="Deadline" @editing="editing">
    {{ selectedDate | formatDate('DD MMM, YYYY') }}
    <datepicker
        v-if="showDatePicker"
        :inline="true"
        @selected="selectedDateCallback"
        v-model="selectedDate"
    ></datepicker>
  </objective-input-decoration>
</template>

<script>
import ObjectiveInputDecoration from "./ObjectiveInputDecoration";
import Datepicker from 'vuejs-datepicker';
import axios from "../plugins/axios";

export default {
  props: ['date', 'objectiveId'],
  data() {
    return {
      showDatePicker: false,
      selectedDate: new Date(this.date),
    }
  },
  methods: {
    editing() {
      this.showDatePicker = true
    },
    selectedDateCallback(date) {
      this.showDatePicker = false
      axios.patch(
          this.$routes.generate('objective_elements_id', {id: this.objectiveId}) + '.json',
          {objective_element: {due_date: this.$options.filters.formatDate(date, 'DD MMM, YYYY')} }
      )
    }
  },
  components: {
    ObjectiveInputDecoration,
    Datepicker
  }
}
</script>

<style >
</style>