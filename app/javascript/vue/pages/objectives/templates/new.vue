<template>
  <bkt-form @submit="handleSubmit" :loading="loading">
    <new-entity-title>
      <h1 v-if="this.editId">Update target template</h1>
      <h1 v-else>Create a target template</h1>
    </new-entity-title>

    <new-entity-subtitle>Target informations</new-entity-subtitle>
    <bkt-input-form v-model="title" class="mt-3" placeholder="Title"></bkt-input-form>
    <bkt-input-error-text v-if="titleError">Fill the title please</bkt-input-error-text>
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
import BktInputErrorText from "../../../components/BktInputErrorText";
import axios from "../../../plugins/axios";

export default {
  props: ['editId'],
  data() {
    return {
      loading: false,
      title: null,
      titleError: false,
      desc: null,
      indicator: {
        indicator_type: 'boolean',
        starting_value: null,
        target_value: null,
        multiChoiceList: ['Option 1 (will the target value)']
      },
      canEmployeeEdit: true,
      canEmployeeView: true,
    }
  },
  async created() {
    if (this.editId) {
      const entity = (await axios.get(`/objective/templates/${this.editId}`)).data['objective/template']
      this.mergeToCurrentTemplate(entity)
    }
  },
  methods: {
    mergeToCurrentTemplate(template) {
      this.title = template.title
      this.desc = template.description
      this.canEmployeeEdit = template.can_employee_edit
      this.canEmployeeView = template.can_employee_view
      this.indicator.indicator_type = template.objective_indicator.indicator_type
      // this.starting_value = template.objective_indicator.indicator_type == 'multi_choice' ? '' : ''
      this.indicator.starting_value = template.objective_indicator.options.starting_value
      this.indicator.target_value = template.objective_indicator.options.target_value
      this.indicator.multiChoiceList = []

      const regex = new RegExp(/^choice_.*/)
      for (const opt in template.objective_indicator.options) {
        if (regex.test(opt)) this.indicator.multiChoiceList.push(template.objective_indicator.options[opt])
      }
    },
    async handleSubmit() {
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
      if (!this.title) {
        this.titleError = true
        return
      }

      this.loading = true
      try {
        const toSend = {
          title: this.title,
          description: this.desc,
          indicator: this.indicator,
          can_employee_edit: this.canEmployeeEdit,
          can_employee_view: this.canEmployeeView,
        }

        if (this.editId) {
          await axios.patch(
              this.$routes.generate('objective_templates_id', {id: this.editId}),
              toSend
          )
        } else {
          await axios.post(
              this.$routes.generate('objective_templates'),
              toSend
          )
        }

      } catch (e) {
        console.log('error', e.response.data) // TODO: maybe a notification ?
      }
      this.loading = false
      window.location.href = this.$routes.generate('objective_templates')
    }
  },
  components: {
    BktInputErrorText,
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