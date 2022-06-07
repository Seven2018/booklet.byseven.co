<template>
  <div class="width-100 h-70vh flex-column-centered justify-content-center">
    <div class="fs-3_5rem">
      👋
    </div>
    <p class="text-center">
      Hey ! It seems there is no
      <span v-if="type === 'roadmap'">target</span>
      to show,<br>
      how about create your first ?</p>

    <div class="mt-3">
      <bkt-button :type="type" :href="href">
        <span v-if="type === 'roadmap'">
          Create my first target
        </span>
      </bkt-button>
    </div>
  </div>
</template>

<script>
import BktButton from "./BktButton";
import BktNewTargetButton from "./BktNewTargetButton";

export default {
  components: {BktButton, BktNewTargetButton},
  props: ['type', 'href']
}
</script>