
<template>
  <bkt-index-skeleton>
    <template v-slot:title>Targets</template>
    <template v-slot:body>
      <target-index-search></target-index-search>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import TargetIndexSearch from "./TargetIndexSearch";

export default {
  components: {BktIndexSkeleton, TargetIndexSearch}
}
</script>