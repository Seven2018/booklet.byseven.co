
<template>
  <div class="width-80 py-5 mx-auto">
    <div class="flex-row-between-centered mb-5">
      <div class="flex-column">
        <h1 class="font-weight-700 fs-2_4rem">
          <slot name="title"></slot>
        </h1>
      </div>
      <div class="flex-column">
        <slot name="create-index">
          <bkt-new-target-button></bkt-new-target-button>
        </slot>
      </div>
    </div>

    <bkt-box :class="bodyClass">
      <slot name="body"></slot>
    </bkt-box>
  </div>
</template>

<script>
import BktBox from "./BktBox";
import BktNewTargetButton from "./BktNewTargetButton";

export default {
  props: ['bodyClass'],
  components: {BktBox, BktNewTargetButton}
}
</script>