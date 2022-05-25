
<template>
  <div class="width-80 mt-5 mx-auto">
    <div class="flex-row-between-centered mb-5">
      <div class="flex-column">
        <h1 class="font-weight-700 fs-2_4rem">
          <slot name="title"></slot>
        </h1>
      </div>
      <div class="flex-column">
        <bkt-new-target-button></bkt-new-target-button>
      </div>
    </div>

    <bkt-box>
      <slot name="body"></slot>
    </bkt-box>
  </div>
</template>

<script>
import BktBox from "./BktBox";
import BktNewTargetButton from "./BktNewTargetButton";

export default {
  components: {BktBox, BktNewTargetButton}
}
</script>