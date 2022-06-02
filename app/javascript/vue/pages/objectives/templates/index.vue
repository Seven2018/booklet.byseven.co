
<template>
  <bkt-index-skeleton>
    <template v-slot:title>Target templates</template>
    <template v-slot:create-index>
      <bkt-button
          type="blue"
          iconify="ant-design:plus-circle-outlined"
          :href="$routes.generate('objective_templates_new')"
      >New template</bkt-button>
    </template>
    <template v-slot:body>
      test table
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";

export default {
  components: {
    BktButton,
    BktIndexSkeleton,
  }
}
</script>