<template>
  <bkt-form @submit="handleSubmit" :loading="loading">
    <new-entity-title>Create a target template</new-entity-title>

    <new-entity-subtitle>Target informations</new-entity-subtitle>
    <bkt-input-form v-model="title" class="mt-3" placeholder="Title"></bkt-input-form>
    <bkt-textarea-form v-model="desc" class="mt-3 " inputClass="min-h-10rem" placeholder="Description"></bkt-textarea-form>

    <new-entity-subtitle class="mt-5">Target Indicator</new-entity-subtitle>
    <target-indicator-values v-model="indicator" class="mt-3"></target-indicator-values>

    <new-entity-subtitle class="mt-5">Target settings</new-entity-subtitle>
    <div class="flex-row-between-centered mt-2">
      <p class="fs-1_2rem font-weight-500 bkt-light-grey6 mt-2">Employee can edit target</p>

      <bkt-toggle v-model="canEmployeeEdit"></bkt-toggle>
    </div>
    <div class="flex-row-between-centered mt-2">
      <p class="fs-1_2rem font-weight-500 bkt-light-grey6 mt-2">Employee can view target</p>

      <bkt-toggle v-model="canEmployeeView"></bkt-toggle>
    </div>
  </bkt-form>
</template>

<script>
import NewEntityTitle from "../../../components/NewEntityTitle";
import NewEntitySubtitle from "../../../components/NewEntitySubtitle";
import BktForm from "../../../components/BktForm";
import BktInputForm from "../../../components/BktInputForm";
import BktTextareaForm from "../../../components/BktTextareaForm";
import TargetIndicatorValues from "../../../components/TargetIndicatorValues";
import BktToggle from '../../../components/BktToggle'
import BktSpinner from "../../../components/BktSpinner";

export default {
  data() {
    return {
      loading: false,
      title: null,
      desc: null,
      indicator: {
        type: 'boolean',
        starting_value: null,
        target_value: null,
        multiChoiceList: ['Option 1 (will the target value)']
      },
      canEmployeeEdit: true,
      canEmployeeView: true,
    }
  },
  methods: {
    handleSubmit() {
      // elements
      // objective_element[title]
      // objective_element[description]

      // fields for indicator
      // indicator[indicator_type]
      // indicator[options][starting_value]
      // indicator[options][target_value]
      // indicator[options][choice_1] (choice_2,3,4 as many as user generated)

      // can_employee_edit
      // can_employee_view
      console.log('submit', this.title, this.desc, this.indicator)
    }
  },
  components: {
    BktSpinner,
    TargetIndicatorValues,
    BktTextareaForm,
    BktInputForm,
    BktForm,
    NewEntitySubtitle,
    NewEntityTitle,
    BktToggle
  }
}
</script>