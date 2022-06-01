<template>
  <bkt-form>
    <new-entity-title>Create a target template</new-entity-title>

    <new-entity-subtitle>Target informations</new-entity-subtitle>
    <bkt-input-form class="mt-3" placeholder="Title"></bkt-input-form>
    <bkt-textarea-form class="mt-3 " inputClass="min-h-10rem" placeholder="Description"></bkt-textarea-form>

    <new-entity-subtitle class="mt-3">Target Indicator</new-entity-subtitle>
    <target-indicator-values class="mt-3"></target-indicator-values>

    <new-entity-subtitle class="mt-3">Target settings</new-entity-subtitle>
    <div class="flex-row-between-centered mt-2">
      <p class="fs-1_2rem font-weight-500 bkt-light-grey6 mt-2">Employee can edit completion</p>

      <div>toggle</div>
    </div>
    <div class="flex-row-between-centered mt-2">
      <p class="fs-1_2rem font-weight-500 bkt-light-grey6 mt-2">Employee can edit completion</p>

      <div>toggle</div>
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

export default {
  components: {TargetIndicatorValues, BktTextareaForm, BktInputForm, BktForm, NewEntitySubtitle, NewEntityTitle}
}
</script>