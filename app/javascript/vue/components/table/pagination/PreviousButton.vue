<template>
    <bkt-button
        v-if="pagination.prev_page"
        @click="method(pagination.prev_page)"
        type="none"

    >
    <div class='paginate__previous-button paginate__button-blue'>
      <span class="iconify" data-icon="fontisto:angle-left"></span>
      <p>Previous</p>
    </div>
  </bkt-button>
</template>

<script>
import BktButton from "../../BktButton";

export default {
  components: {BktButton},
  props: {
    pagination: Object,
    method: { type: Function },
  }
}
</script>
