<template>
  <bkt-button
      v-if="pagination.next_page"
      @click="method(pagination.next_page)"
    >
      <div class="paginate__next-button paginate__button-blue">
        <p>Next</p>
        <span class="iconify" data-icon="fontisto:angle-right"></span>
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
